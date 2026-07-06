# Devoir ELK — Gestion d'une bibliothèque numérique

**Auteur : MANTSOUAKA MPINDOU Franck Arthur**

Solution complète du devoir Elasticsearch/Kibana (index `library`, 20 livres, requêtes, enrichissement, ré-indexation, transformations, dashboard).

## Contenu du dossier

| Fichier / dossier | Rôle |
|---|---|
| `RENDU.md` | **Livrable principal** : chaque question → requête complète + résultat JSON réel. |
| `elk/docker-compose.yml` | Stack Elasticsearch 8.15.3 + Kibana 8.15.3. |
| `queries/` | Tous les corps de requêtes (`.json`, `.ndjson`) + `run_all.sh` qui initialise les données. |
| `dashboard_bibliotheque.png` | Capture d'écran du dashboard Kibana (Partie F). |
| `DevoirES.pdf` | Énoncé original. |

## Environnement

- Elasticsearch **8.15.3** + Kibana **8.15.3** via Docker Compose (Ubuntu).
- Sécurité désactivée (`xpack.security.enabled=false`) : **uniquement pour ce TP local**, jamais en production.
- Elasticsearch : http://localhost:9200 — Kibana : http://localhost:5601

## Reproduire de zéro

### 0. Cloner le dépôt

```bash
git clone https://github.com/Dakar2024/DEVOIR---ELK.git
cd DEVOIR---ELK
```

### 1. Lancer la stack Docker

Depuis le dossier `elk/` du projet :

```bash
docker compose up -d
```

- Elasticsearch : http://localhost:9200
- Kibana : http://localhost:5601

### 2. Attendre qu'Elasticsearch soit prêt

```bash
curl http://localhost:9200/_cluster/health
```

Attendre que `"status"` soit `"green"` ou `"yellow"` avant de continuer.

### 3. Initialiser les données

> ℹ️ Le script détecte automatiquement son propre emplacement : **aucun chemin à modifier**,
> il fonctionne quel que soit le PC ou le dossier d'installation. Il faut simplement que
> `bash`, `curl` et `python3` soient disponibles. Pour cibler un autre hôte Elasticsearch :
> `ES="http://mon-hote:9200" bash run_all.sh`.

Depuis le dossier `queries/` du projet :

```bash
bash run_all.sh
```

Ce script effectue dans l'ordre :
- Création de l'index `library` avec le mapping complet
- Indexation des 20 livres via Bulk API
- Exécution de toutes les requêtes (parties A à E)
- Régénération de `RENDU.md` avec les résultats JSON réels

### 4. Vérifier l'indexation

```bash
curl http://localhost:9200/library/_count
```

Résultat attendu : `"count": 20`

### 5. Consulter les résultats

Ouvrir `RENDU.md` — chaque question du devoir y figure avec la requête complète et le résultat JSON retourné par Elasticsearch.

## Note technique — champ `publication_year`

Le sujet spécifie `format: "yyyy"`, mais *The Odyssey* a l'année `"-800"` (800 av. J.-C.), rejetée par `yyyy`
(year-of-era, sans années négatives). Le format est étendu à **`"yyyy||u"`** (`u` = année proleptique signée)
pour indexer les 20 livres sans altérer les données. Les requêtes du sujet restent identiques.

## Résumé des résultats clés

- **20 livres** indexés dans `library`.
- Enrichissement `popularity_tag` : **5 Best Seller · 10 Popular · 5 Regular**.
- Ré-indexation `library_v2` : 20 documents + champ `edition = "Original"`.
- Transform pivot (disponibles par genre) et transform latest (dernier livre par auteur) : OK.
- Disponibilité : **14 Available / 6 Checked Out**.


```bash 
Presenter par : MANTSOUAKA MPINDOU Franck Arthur 
Sous la Supervision de : Monsieur Ismaila Pascal MBAYE
````