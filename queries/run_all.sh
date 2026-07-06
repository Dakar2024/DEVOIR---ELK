#!/usr/bin/env bash
# Devoir ELK - Gestion d'une bibliotheque numerique
# Auteur : Arthur MANTSOUAKA
# Genere RENDU.md : chaque question -> requete complete + resultat JSON reel.
set -u
# Chemins detectes automatiquement -> le script fonctionne sur n'importe quelle machine,
# quel que soit l'emplacement du projet. Aucune modification manuelle necessaire.
# (ES peut etre surcharge : ES="http://mon-hote:9200" bash run_all.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ES="${ES:-http://localhost:9200}"
Q="$SCRIPT_DIR"                    # dossier queries/ (celui de ce script)
OUT="$SCRIPT_DIR/../RENDU.md"      # RENDU.md a la racine du projet

pp() { python3 -m json.tool 2>/dev/null || cat; }   # pretty-print JSON

# --- helpers d'ecriture markdown ---
h()  { printf '%s\n\n' "$1" >> "$OUT"; }
req_open()  { printf '**Requête :**\n\n```\n' >> "$OUT"; }
code_close(){ printf '```\n\n' >> "$OUT"; }
res_open()  { printf '**Résultat :**\n\n```json\n' >> "$OUT"; }

: > "$OUT"   # reset

cat >> "$OUT" <<'HDR'
# Devoir ELK — Gestion d'une bibliothèque numérique

**Auteur : Arthur MANTSOUAKA**

Stack : Elasticsearch 8.15.3 + Kibana 8.15.3 (Docker Compose, sécurité désactivée pour ce TP local).
Chaque question ci-dessous fournit **la requête complète** puis **le résultat JSON** réellement retourné par Elasticsearch.

> **Note technique (mapping) :** le sujet spécifie `format: "yyyy"` pour `publication_year`, mais le livre *The Odyssey* a l'année `"-800"` (800 av. J.-C.). Le format `yyyy` (year-of-era) rejette les années négatives (`date_time_parse_exception`). Le format est donc étendu à **`"yyyy||u"`** (`u` = année proleptique signée) pour indexer les 20 livres sans altérer les données. Les requêtes restent identiques.

---

HDR

# ---------- Q0 : cluster stats ----------
h "## 0. Identification du cluster"
req_open
printf 'GET /_cluster/stats?filter_path=cluster_name,cluster_uuid,nodes.count,indices.count,indices.docs\n' >> "$OUT"
code_close
res_open
curl -s "$ES/_cluster/stats?filter_path=cluster_name,cluster_uuid,nodes.count,indices.count,indices.docs" | pp >> "$OUT"
code_close
h "---"

# ---------- Q1 : mapping ----------
curl -s -X DELETE "$ES/library" >/dev/null
curl -s -X DELETE "$ES/library_v2" >/dev/null
curl -s -X DELETE "$ES/books_available_by_genre" >/dev/null
curl -s -X DELETE "$ES/latest_book_per_author" >/dev/null
curl -s -X POST "$ES/_transform/books_available_by_genre/_stop?force=true" >/dev/null 2>&1
curl -s -X DELETE "$ES/_transform/books_available_by_genre?force=true" >/dev/null 2>&1
curl -s -X POST "$ES/_transform/latest_book_per_author/_stop?force=true" >/dev/null 2>&1
curl -s -X DELETE "$ES/_transform/latest_book_per_author?force=true" >/dev/null 2>&1

h "## 1. Création du mapping de l'index \`library\`"
req_open
printf 'PUT /library\n' >> "$OUT"; cat "$Q/01_mapping.json" >> "$OUT"
code_close
res_open
curl -s -X PUT "$ES/library" -H "Content-Type: application/json" --data-binary @"$Q/01_mapping.json" | pp >> "$OUT"
code_close
h "---"

# ---------- Q2 : bulk ----------
h "## 2. Indexation des 20 livres via Bulk API"
h "Le corps NDJSON complet est dans \`queries/02_bulk.ndjson\`. Extrait des 2 premières lignes :"
printf '```\n' >> "$OUT"
printf 'POST /library/_bulk\n' >> "$OUT"
head -n 4 "$Q/02_bulk.ndjson" >> "$OUT"
printf '... (20 documents au total)\n' >> "$OUT"
code_close
res_open
curl -s -X POST "$ES/library/_bulk" -H "Content-Type: application/x-ndjson" --data-binary @"$Q/02_bulk.ndjson" | pp >> "$OUT"
code_close
curl -s "$ES/library/_refresh" >/dev/null
h "**Vérification du nombre de documents indexés :**"
res_open
curl -s "$ES/library/_count?pretty" >> "$OUT"
code_close
h "---"

h "## 3. Questions — requêtes de recherche"

# ---------- Q3.1 term ----------
h "### A.1 — Livres disponibles en \"Science Fiction\" (term sur genre + availability)"
req_open
printf 'GET /library/_search\n' >> "$OUT"; cat "$Q/q1_term.json" >> "$OUT"
code_close
res_open
curl -s "$ES/library/_search?pretty" -H "Content-Type: application/json" --data-binary @"$Q/q1_term.json" >> "$OUT"
code_close
h "---"

# ---------- Q3.2 range ----------
h "### A.2 — Livres publiés après 1950 (range sur publication_year)"
req_open
printf 'GET /library/_search\n' >> "$OUT"; cat "$Q/q2_range.json" >> "$OUT"
code_close
res_open
curl -s "$ES/library/_search?pretty" -H "Content-Type: application/json" --data-binary @"$Q/q2_range.json" >> "$OUT"
code_close
h "---"

# ---------- Q3.3 match ----------
h "### A.3 — Livre contenant \"New\" dans le titre (match sur title)"
req_open
printf 'GET /library/_search\n' >> "$OUT"; cat "$Q/q3_match.json" >> "$OUT"
code_close
res_open
curl -s "$ES/library/_search?pretty" -H "Content-Type: application/json" --data-binary @"$Q/q3_match.json" >> "$OUT"
code_close
h "---"

# ---------- Q3.4 bool must ----------
h "### B.4 — Genre \"Dystopian\" ET note > 4.5 (bool must + range)"
req_open
printf 'GET /library/_search\n' >> "$OUT"; cat "$Q/q4_bool_must.json" >> "$OUT"
code_close
res_open
curl -s "$ES/library/_search?pretty" -H "Content-Type: application/json" --data-binary @"$Q/q4_bool_must.json" >> "$OUT"
code_close
h "---"

# ---------- Q3.5 must_not ----------
h "### B.5 — Tous les livres sauf le genre \"Dystopian\" (bool must_not)"
req_open
printf 'GET /library/_search\n' >> "$OUT"; cat "$Q/q5_must_not.json" >> "$OUT"
code_close
res_open
curl -s "$ES/library/_search?pretty" -H "Content-Type: application/json" --data-binary @"$Q/q5_must_not.json" >> "$OUT"
code_close
h "---"

# ---------- Q3.6 should ----------
h "### B.6 — Livres disponibles OU note > 4.7 (bool should)"
req_open
printf 'GET /library/_search\n' >> "$OUT"; cat "$Q/q6_should.json" >> "$OUT"
code_close
res_open
curl -s "$ES/library/_search?pretty" -H "Content-Type: application/json" --data-binary @"$Q/q6_should.json" >> "$OUT"
code_close
h "---"

# ---------- Q7 enrichment ----------
h "## 7. Enrichissement — champ \`popularity_tag\` selon la note"
h "Règle : note > 4.8 → *Best Seller* · note ∈ [4.5 ; 4.8] → *Popular* · note < 4.5 → *Regular*."
h "L'enrichissement repose sur une plage numérique : on utilise un **ingest pipeline** avec un *script processor* (plus adapté qu'une enrich policy, qui fait du lookup par clé)."
h "**Étape 1 — Création du pipeline :**"
req_open
printf 'PUT /_ingest/pipeline/popularity_tagger\n' >> "$OUT"; cat "$Q/q7_pipeline.json" >> "$OUT"
code_close
res_open
curl -s -X PUT "$ES/_ingest/pipeline/popularity_tagger" -H "Content-Type: application/json" --data-binary @"$Q/q7_pipeline.json" | pp >> "$OUT"
code_close
h "**Étape 2 — Application du pipeline aux documents existants (update_by_query) :**"
req_open
printf 'POST /library/_update_by_query?pipeline=popularity_tagger\n' >> "$OUT"
code_close
res_open
curl -s -X POST "$ES/library/_update_by_query?pipeline=popularity_tagger&refresh=true" | pp >> "$OUT"
code_close
h "**Vérification — répartition des tags** (le champ \`popularity_tag\` créé dynamiquement est un \`text\` avec sous-champ \`.keyword\`, sur lequel on agrège) **:**"
req_open
cat >> "$OUT" <<'AGG'
GET /library/_search
{
  "size": 0,
  "aggs": {
    "par_tag": { "terms": { "field": "popularity_tag.keyword" } }
  }
}
AGG
code_close
res_open
curl -s "$ES/library/_search?pretty&filter_path=aggregations" -H "Content-Type: application/json" -d '{"size":0,"aggs":{"par_tag":{"terms":{"field":"popularity_tag.keyword"}}}}' >> "$OUT"
code_close
h "**Aperçu de 3 documents enrichis :**"
res_open
curl -s "$ES/library/_search?pretty&filter_path=hits.hits._id,hits.hits._source.title,hits.hits._source.rating,hits.hits._source.popularity_tag" -H "Content-Type: application/json" -d '{"size":3,"sort":[{"rating":"desc"}]}' >> "$OUT"
code_close
h "---"

# ---------- Q8 reindex ----------
h "## 8. Ré-indexation vers \`library_v2\` (+ champ \`edition\` = \"Original\")"
h "**Étape 1 — Création de \`library_v2\` (mapping incluant \`edition\` et \`popularity_tag\`) :**"
req_open
printf 'PUT /library_v2\n' >> "$OUT"; cat "$Q/library_v2_mapping.json" >> "$OUT"
code_close
res_open
curl -s -X PUT "$ES/library_v2" -H "Content-Type: application/json" --data-binary @"$Q/library_v2_mapping.json" | pp >> "$OUT"
code_close
h "**Étape 2 — Reindex avec ajout de \`edition\` :**"
req_open
printf 'POST /_reindex\n' >> "$OUT"; cat "$Q/q8_reindex.json" >> "$OUT"
code_close
res_open
curl -s -X POST "$ES/_reindex?refresh=true" -H "Content-Type: application/json" --data-binary @"$Q/q8_reindex.json" | pp >> "$OUT"
code_close
h "**Vérification — un document de \`library_v2\` :**"
res_open
curl -s "$ES/library_v2/_doc/1?pretty" >> "$OUT"
code_close
h "---"

# ---------- Q9 pivot transform ----------
h "## 9. Transformation *pivot* — nombre de livres disponibles par genre"
req_open
printf 'PUT /_transform/books_available_by_genre\n' >> "$OUT"; cat "$Q/q9_pivot.json" >> "$OUT"
code_close
res_open
curl -s -X PUT "$ES/_transform/books_available_by_genre" -H "Content-Type: application/json" --data-binary @"$Q/q9_pivot.json" | pp >> "$OUT"
code_close
curl -s -X POST "$ES/_transform/books_available_by_genre/_start" >/dev/null
# attendre la fin du batch
for i in $(seq 1 30); do
  st=$(curl -s "$ES/_transform/books_available_by_genre/_stats?filter_path=transforms.state" | python3 -c "import sys,json;print(json.load(sys.stdin)['transforms'][0]['state'])" 2>/dev/null)
  [ "$st" = "stopped" ] && break
  sleep 2
done
curl -s "$ES/books_available_by_genre/_refresh" >/dev/null
h "**Démarrage :** \`POST /_transform/books_available_by_genre/_start\` — puis résultat de l'index de destination :"
req_open
printf 'GET /books_available_by_genre/_search\n' >> "$OUT"
code_close
res_open
curl -s "$ES/books_available_by_genre/_search?pretty&filter_path=hits.hits._source" -H "Content-Type: application/json" -d '{"size":50,"sort":[{"genre":"asc"}]}' >> "$OUT"
code_close
h "---"

# ---------- Q10 latest transform ----------
h "## 10. Transformation *latest* — dernier livre publié par auteur"
req_open
printf 'PUT /_transform/latest_book_per_author\n' >> "$OUT"; cat "$Q/q10_latest.json" >> "$OUT"
code_close
res_open
curl -s -X PUT "$ES/_transform/latest_book_per_author" -H "Content-Type: application/json" --data-binary @"$Q/q10_latest.json" | pp >> "$OUT"
code_close
curl -s -X POST "$ES/_transform/latest_book_per_author/_start" >/dev/null
for i in $(seq 1 30); do
  st=$(curl -s "$ES/_transform/latest_book_per_author/_stats?filter_path=transforms.state" | python3 -c "import sys,json;print(json.load(sys.stdin)['transforms'][0]['state'])" 2>/dev/null)
  [ "$st" = "stopped" ] && break
  sleep 2
done
curl -s "$ES/latest_book_per_author/_refresh" >/dev/null
h "**Démarrage :** \`POST /_transform/latest_book_per_author/_start\` — puis résultat de l'index de destination :"
req_open
printf 'GET /latest_book_per_author/_search\n' >> "$OUT"
code_close
res_open
curl -s "$ES/latest_book_per_author/_search?pretty&filter_path=hits.hits._source" -H "Content-Type: application/json" -d '{"size":50,"sort":[{"author.keyword":"asc"}]}' >> "$OUT"
code_close
h "---"

echo "RENDU.md généré."
