# Devoir ELK — Gestion d'une bibliothèque numérique

**Auteur : Arthur MANTSOUAKA**

Stack : Elasticsearch 8.15.3 + Kibana 8.15.3 (Docker Compose, sécurité désactivée pour ce TP local).
Chaque question ci-dessous fournit **la requête complète** puis **le résultat JSON** réellement retourné par Elasticsearch.

> **Note technique (mapping) :** le sujet spécifie `format: "yyyy"` pour `publication_year`, mais le livre *The Odyssey* a l'année `"-800"` (800 av. J.-C.). Le format `yyyy` (year-of-era) rejette les années négatives (`date_time_parse_exception`). Le format est donc étendu à **`"yyyy||u"`** (`u` = année proleptique signée) pour indexer les 20 livres sans altérer les données. Les requêtes restent identiques.

---

## 0. Identification du cluster

**Requête :**

```
GET /_cluster/stats?filter_path=cluster_name,cluster_uuid,nodes.count,indices.count,indices.docs
```

**Résultat :**

```json
{
    "cluster_name": "docker-cluster",
    "cluster_uuid": "aWQjlfWWRFGhmRl7tBvyGg",
    "indices": {
        "count": 35,
        "docs": {
            "count": 230,
            "deleted": 4,
            "total_size_in_bytes": 2704598
        }
    },
    "nodes": {
        "count": {
            "total": 1,
            "coordinating_only": 0,
            "data": 1,
            "data_cold": 1,
            "data_content": 1,
            "data_frozen": 1,
            "data_hot": 1,
            "data_warm": 1,
            "index": 0,
            "ingest": 1,
            "master": 1,
            "ml": 1,
            "remote_cluster_client": 1,
            "search": 0,
            "transform": 1,
            "voting_only": 0
        }
    }
}
```

---

## 1. Création du mapping de l'index `library`

**Requête :**

```
PUT /library
{
  "mappings": {
    "properties": {
      "title": { "type": "text", "analyzer": "standard" },
      "author": { "type": "keyword" },
      "publication_year": { "type": "date", "format": "yyyy||u" },
      "genre": { "type": "keyword" },
      "rating": { "type": "float" },
      "availability": { "type": "keyword" },
      "@timestamp": { "type": "date" }
    }
  }
}
```

**Résultat :**

```json
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "library"
}
```

---

## 2. Indexation des 20 livres via Bulk API

Le corps NDJSON complet est dans `queries/02_bulk.ndjson`. Extrait des 2 premières lignes :

```
POST /library/_bulk
{"index": {"_index": "library", "_id": "1"}}
{"title": "Dune", "author": "Frank Herbert", "publication_year": "1965", "genre": "Science Fiction", "rating": 4.8, "availability": "Available", "@timestamp": "2024-09-30T10:00:00Z"}
{"index": {"_index": "library", "_id": "2"}}
{"title": "1984", "author": "George Orwell", "publication_year": "1949", "genre": "Dystopian", "rating": 4.6, "availability": "Checked Out", "@timestamp": "2024-09-30T11:00:00Z"}
... (20 documents au total)
```

**Résultat :**

```json
{
    "errors": false,
    "took": 0,
    "items": [
        {
            "index": {
                "_index": "library",
                "_id": "1",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 0,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "2",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 1,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "3",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 2,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "4",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 3,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "5",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 4,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "6",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 5,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "7",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 6,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "8",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 7,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "9",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 8,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "10",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 9,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "11",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 10,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "12",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 11,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "13",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 12,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "14",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 13,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "15",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 14,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "16",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 15,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "17",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 16,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "18",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 17,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "19",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 18,
                "_primary_term": 1,
                "status": 201
            }
        },
        {
            "index": {
                "_index": "library",
                "_id": "20",
                "_version": 1,
                "result": "created",
                "_shards": {
                    "total": 2,
                    "successful": 1,
                    "failed": 0
                },
                "_seq_no": 19,
                "_primary_term": 1,
                "status": 201
            }
        }
    ]
}
```

**Vérification du nombre de documents indexés :**

**Résultat :**

```json
{
  "count" : 20,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  }
}
```

---

## 3. Questions — requêtes de recherche

### A.1 — Livres disponibles en "Science Fiction" (term sur genre + availability)

**Requête :**

```
GET /library/_search
{
  "query": {
    "bool": {
      "filter": [
        { "term": { "genre": "Science Fiction" } },
        { "term": { "availability": "Available" } }
      ]
    }
  }
}
```

**Résultat :**

```json
{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "library",
        "_id" : "1",
        "_score" : 0.0,
        "_source" : {
          "title" : "Dune",
          "author" : "Frank Herbert",
          "publication_year" : "1965",
          "genre" : "Science Fiction",
          "rating" : 4.8,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T10:00:00Z"
        }
      }
    ]
  }
}
```

---

### A.2 — Livres publiés après 1950 (range sur publication_year)

**Requête :**

```
GET /library/_search
{
  "size": 50,
  "query": {
    "range": {
      "publication_year": { "gt": "1950" }
    }
  }
}
```

**Résultat :**

```json
{
  "took" : 4,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 6,
      "relation" : "eq"
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "library",
        "_id" : "1",
        "_score" : 1.0,
        "_source" : {
          "title" : "Dune",
          "author" : "Frank Herbert",
          "publication_year" : "1965",
          "genre" : "Science Fiction",
          "rating" : 4.8,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T10:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "4",
        "_score" : 1.0,
        "_source" : {
          "title" : "To Kill a Mockingbird",
          "author" : "Harper Lee",
          "publication_year" : "1960",
          "genre" : "Fiction",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T13:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "9",
        "_score" : 1.0,
        "_source" : {
          "title" : "The Catcher in the Rye",
          "author" : "J.D. Salinger",
          "publication_year" : "1951",
          "genre" : "Fiction",
          "rating" : 4.3,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T18:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "10",
        "_score" : 1.0,
        "_source" : {
          "title" : "The Lord of the Rings",
          "author" : "J.R.R. Tolkien",
          "publication_year" : "1954",
          "genre" : "Fantasy",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T19:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "11",
        "_score" : 1.0,
        "_source" : {
          "title" : "Harry Potter and the Philosopher's Stone",
          "author" : "J.K. Rowling",
          "publication_year" : "1997",
          "genre" : "Fantasy",
          "rating" : 4.7,
          "availability" : "Checked Out",
          "@timestamp" : "2024-09-30T20:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "12",
        "_score" : 1.0,
        "_source" : {
          "title" : "The Shining",
          "author" : "Stephen King",
          "publication_year" : "1977",
          "genre" : "Horror",
          "rating" : 4.6,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T21:00:00Z"
        }
      }
    ]
  }
}
```

---

### A.3 — Livre contenant "New" dans le titre (match sur title)

**Requête :**

```
GET /library/_search
{
  "query": {
    "match": { "title": "New" }
  }
}
```

**Résultat :**

```json
{
  "took" : 7,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 2.5243158,
    "hits" : [
      {
        "_index" : "library",
        "_id" : "5",
        "_score" : 2.5243158,
        "_source" : {
          "title" : "Brave New World",
          "author" : "Aldous Huxley",
          "publication_year" : "1932",
          "genre" : "Dystopian",
          "rating" : 4.5,
          "availability" : "Checked Out",
          "@timestamp" : "2024-09-30T14:00:00Z"
        }
      }
    ]
  }
}
```

---

### B.4 — Genre "Dystopian" ET note > 4.5 (bool must + range)

**Requête :**

```
GET /library/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "genre": "Dystopian" } },
        { "range": { "rating": { "gt": 4.5 } } }
      ]
    }
  }
}
```

**Résultat :**

```json
{
  "took" : 4,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 1,
      "relation" : "eq"
    },
    "max_score" : 3.1282315,
    "hits" : [
      {
        "_index" : "library",
        "_id" : "2",
        "_score" : 3.1282315,
        "_source" : {
          "title" : "1984",
          "author" : "George Orwell",
          "publication_year" : "1949",
          "genre" : "Dystopian",
          "rating" : 4.6,
          "availability" : "Checked Out",
          "@timestamp" : "2024-09-30T11:00:00Z"
        }
      }
    ]
  }
}
```

---

### B.5 — Tous les livres sauf le genre "Dystopian" (bool must_not)

**Requête :**

```
GET /library/_search
{
  "size": 50,
  "query": {
    "bool": {
      "must_not": [
        { "term": { "genre": "Dystopian" } }
      ]
    }
  }
}
```

**Résultat :**

```json
{
  "took" : 4,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 18,
      "relation" : "eq"
    },
    "max_score" : 0.0,
    "hits" : [
      {
        "_index" : "library",
        "_id" : "1",
        "_score" : 0.0,
        "_source" : {
          "title" : "Dune",
          "author" : "Frank Herbert",
          "publication_year" : "1965",
          "genre" : "Science Fiction",
          "rating" : 4.8,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T10:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "3",
        "_score" : 0.0,
        "_source" : {
          "title" : "The Hobbit",
          "author" : "J.R.R. Tolkien",
          "publication_year" : "1937",
          "genre" : "Fantasy",
          "rating" : 4.7,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T12:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "4",
        "_score" : 0.0,
        "_source" : {
          "title" : "To Kill a Mockingbird",
          "author" : "Harper Lee",
          "publication_year" : "1960",
          "genre" : "Fiction",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T13:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "6",
        "_score" : 0.0,
        "_source" : {
          "title" : "The Great Gatsby",
          "author" : "F. Scott Fitzgerald",
          "publication_year" : "1925",
          "genre" : "Fiction",
          "rating" : 4.4,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T15:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "7",
        "_score" : 0.0,
        "_source" : {
          "title" : "Moby Dick",
          "author" : "Herman Melville",
          "publication_year" : "1851",
          "genre" : "Fiction",
          "rating" : 4.1,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T16:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "8",
        "_score" : 0.0,
        "_source" : {
          "title" : "Pride and Prejudice",
          "author" : "Jane Austen",
          "publication_year" : "1813",
          "genre" : "Romance",
          "rating" : 4.9,
          "availability" : "Checked Out",
          "@timestamp" : "2024-09-30T17:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "9",
        "_score" : 0.0,
        "_source" : {
          "title" : "The Catcher in the Rye",
          "author" : "J.D. Salinger",
          "publication_year" : "1951",
          "genre" : "Fiction",
          "rating" : 4.3,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T18:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "10",
        "_score" : 0.0,
        "_source" : {
          "title" : "The Lord of the Rings",
          "author" : "J.R.R. Tolkien",
          "publication_year" : "1954",
          "genre" : "Fantasy",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T19:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "11",
        "_score" : 0.0,
        "_source" : {
          "title" : "Harry Potter and the Philosopher's Stone",
          "author" : "J.K. Rowling",
          "publication_year" : "1997",
          "genre" : "Fantasy",
          "rating" : 4.7,
          "availability" : "Checked Out",
          "@timestamp" : "2024-09-30T20:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "12",
        "_score" : 0.0,
        "_source" : {
          "title" : "The Shining",
          "author" : "Stephen King",
          "publication_year" : "1977",
          "genre" : "Horror",
          "rating" : 4.6,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T21:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "13",
        "_score" : 0.0,
        "_source" : {
          "title" : "Frankenstein",
          "author" : "Mary Shelley",
          "publication_year" : "1818",
          "genre" : "Horror",
          "rating" : 4.5,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T22:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "14",
        "_score" : 0.0,
        "_source" : {
          "title" : "Dracula",
          "author" : "Bram Stoker",
          "publication_year" : "1897",
          "genre" : "Horror",
          "rating" : 4.4,
          "availability" : "Checked Out",
          "@timestamp" : "2024-09-30T23:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "15",
        "_score" : 0.0,
        "_source" : {
          "title" : "War and Peace",
          "author" : "Leo Tolstoy",
          "publication_year" : "1869",
          "genre" : "Historical Fiction",
          "rating" : 4.3,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T00:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "16",
        "_score" : 0.0,
        "_source" : {
          "title" : "The Odyssey",
          "author" : "Homer",
          "publication_year" : "-800",
          "genre" : "Epic",
          "rating" : 4.7,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T01:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "17",
        "_score" : 0.0,
        "_source" : {
          "title" : "Crime and Punishment",
          "author" : "Fyodor Dostoevsky",
          "publication_year" : "1866",
          "genre" : "Philosophical Fiction",
          "rating" : 4.8,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T02:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "18",
        "_score" : 0.0,
        "_source" : {
          "title" : "The Brothers Karamazov",
          "author" : "Fyodor Dostoevsky",
          "publication_year" : "1880",
          "genre" : "Philosophical Fiction",
          "rating" : 4.9,
          "availability" : "Checked Out",
          "@timestamp" : "2024-10-01T03:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "19",
        "_score" : 0.0,
        "_source" : {
          "title" : "Anna Karenina",
          "author" : "Leo Tolstoy",
          "publication_year" : "1877",
          "genre" : "Romance",
          "rating" : 4.7,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T04:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "20",
        "_score" : 0.0,
        "_source" : {
          "title" : "Les Misérables",
          "author" : "Victor Hugo",
          "publication_year" : "1862",
          "genre" : "Historical Fiction",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T05:00:00Z"
        }
      }
    ]
  }
}
```

---

### B.6 — Livres disponibles OU note > 4.7 (bool should)

**Requête :**

```
GET /library/_search
{
  "size": 50,
  "query": {
    "bool": {
      "should": [
        { "term": { "availability": "Available" } },
        { "range": { "rating": { "gt": 4.7 } } }
      ],
      "minimum_should_match": 1
    }
  }
}
```

**Résultat :**

```json
{
  "took" : 4,
  "timed_out" : false,
  "_shards" : {
    "total" : 1,
    "successful" : 1,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : {
      "value" : 16,
      "relation" : "eq"
    },
    "max_score" : 1.3703737,
    "hits" : [
      {
        "_index" : "library",
        "_id" : "1",
        "_score" : 1.3703737,
        "_source" : {
          "title" : "Dune",
          "author" : "Frank Herbert",
          "publication_year" : "1965",
          "genre" : "Science Fiction",
          "rating" : 4.8,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T10:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "4",
        "_score" : 1.3703737,
        "_source" : {
          "title" : "To Kill a Mockingbird",
          "author" : "Harper Lee",
          "publication_year" : "1960",
          "genre" : "Fiction",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T13:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "10",
        "_score" : 1.3703737,
        "_source" : {
          "title" : "The Lord of the Rings",
          "author" : "J.R.R. Tolkien",
          "publication_year" : "1954",
          "genre" : "Fantasy",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T19:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "17",
        "_score" : 1.3703737,
        "_source" : {
          "title" : "Crime and Punishment",
          "author" : "Fyodor Dostoevsky",
          "publication_year" : "1866",
          "genre" : "Philosophical Fiction",
          "rating" : 4.8,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T02:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "20",
        "_score" : 1.3703737,
        "_source" : {
          "title" : "Les Misérables",
          "author" : "Victor Hugo",
          "publication_year" : "1862",
          "genre" : "Historical Fiction",
          "rating" : 4.9,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T05:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "8",
        "_score" : 1.0,
        "_source" : {
          "title" : "Pride and Prejudice",
          "author" : "Jane Austen",
          "publication_year" : "1813",
          "genre" : "Romance",
          "rating" : 4.9,
          "availability" : "Checked Out",
          "@timestamp" : "2024-09-30T17:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "18",
        "_score" : 1.0,
        "_source" : {
          "title" : "The Brothers Karamazov",
          "author" : "Fyodor Dostoevsky",
          "publication_year" : "1880",
          "genre" : "Philosophical Fiction",
          "rating" : 4.9,
          "availability" : "Checked Out",
          "@timestamp" : "2024-10-01T03:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "3",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "The Hobbit",
          "author" : "J.R.R. Tolkien",
          "publication_year" : "1937",
          "genre" : "Fantasy",
          "rating" : 4.7,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T12:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "6",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "The Great Gatsby",
          "author" : "F. Scott Fitzgerald",
          "publication_year" : "1925",
          "genre" : "Fiction",
          "rating" : 4.4,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T15:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "7",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "Moby Dick",
          "author" : "Herman Melville",
          "publication_year" : "1851",
          "genre" : "Fiction",
          "rating" : 4.1,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T16:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "9",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "The Catcher in the Rye",
          "author" : "J.D. Salinger",
          "publication_year" : "1951",
          "genre" : "Fiction",
          "rating" : 4.3,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T18:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "12",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "The Shining",
          "author" : "Stephen King",
          "publication_year" : "1977",
          "genre" : "Horror",
          "rating" : 4.6,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T21:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "13",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "Frankenstein",
          "author" : "Mary Shelley",
          "publication_year" : "1818",
          "genre" : "Horror",
          "rating" : 4.5,
          "availability" : "Available",
          "@timestamp" : "2024-09-30T22:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "15",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "War and Peace",
          "author" : "Leo Tolstoy",
          "publication_year" : "1869",
          "genre" : "Historical Fiction",
          "rating" : 4.3,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T00:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "16",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "The Odyssey",
          "author" : "Homer",
          "publication_year" : "-800",
          "genre" : "Epic",
          "rating" : 4.7,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T01:00:00Z"
        }
      },
      {
        "_index" : "library",
        "_id" : "19",
        "_score" : 0.37037376,
        "_source" : {
          "title" : "Anna Karenina",
          "author" : "Leo Tolstoy",
          "publication_year" : "1877",
          "genre" : "Romance",
          "rating" : 4.7,
          "availability" : "Available",
          "@timestamp" : "2024-10-01T04:00:00Z"
        }
      }
    ]
  }
}
```

---

## 7. Enrichissement — champ `popularity_tag` selon la note

Règle : note > 4.8 → *Best Seller* · note ∈ [4.5 ; 4.8] → *Popular* · note < 4.5 → *Regular*.

L'enrichissement repose sur une plage numérique : on utilise un **ingest pipeline** avec un *script processor* (plus adapté qu'une enrich policy, qui fait du lookup par clé).

**Étape 1 — Création du pipeline :**

**Requête :**

```
PUT /_ingest/pipeline/popularity_tagger
{
  "description": "Ajoute popularity_tag selon la note (rating)",
  "processors": [
    {
      "script": {
        "lang": "painless",
        "source": "if (ctx.rating > 4.8) { ctx.popularity_tag = 'Best Seller' } else if (ctx.rating >= 4.5) { ctx.popularity_tag = 'Popular' } else { ctx.popularity_tag = 'Regular' }"
      }
    }
  ]
}
```

**Résultat :**

```json
{
    "acknowledged": true
}
```

**Étape 2 — Application du pipeline aux documents existants (update_by_query) :**

**Requête :**

```
POST /library/_update_by_query?pipeline=popularity_tagger
```

**Résultat :**

```json
{
    "took": 128,
    "timed_out": false,
    "total": 20,
    "updated": 20,
    "deleted": 0,
    "batches": 1,
    "version_conflicts": 0,
    "noops": 0,
    "retries": {
        "bulk": 0,
        "search": 0
    },
    "throttled_millis": 0,
    "requests_per_second": -1.0,
    "throttled_until_millis": 0,
    "failures": []
}
```

**Vérification — répartition des tags** (le champ `popularity_tag` créé dynamiquement est un `text` avec sous-champ `.keyword`, sur lequel on agrège) **:**

**Requête :**

```
GET /library/_search
{
  "size": 0,
  "aggs": {
    "par_tag": { "terms": { "field": "popularity_tag.keyword" } }
  }
}
```

**Résultat :**

```json
{
  "aggregations" : {
    "par_tag" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : "Popular",
          "doc_count" : 10
        },
        {
          "key" : "Best Seller",
          "doc_count" : 5
        },
        {
          "key" : "Regular",
          "doc_count" : 5
        }
      ]
    }
  }
}
```

**Aperçu de 3 documents enrichis :**

**Résultat :**

```json
{
  "hits" : {
    "hits" : [
      {
        "_id" : "4",
        "_source" : {
          "rating" : 4.9,
          "title" : "To Kill a Mockingbird",
          "popularity_tag" : "Best Seller"
        }
      },
      {
        "_id" : "8",
        "_source" : {
          "rating" : 4.9,
          "title" : "Pride and Prejudice",
          "popularity_tag" : "Best Seller"
        }
      },
      {
        "_id" : "10",
        "_source" : {
          "rating" : 4.9,
          "title" : "The Lord of the Rings",
          "popularity_tag" : "Best Seller"
        }
      }
    ]
  }
}
```

---

## 8. Ré-indexation vers `library_v2` (+ champ `edition` = "Original")

**Étape 1 — Création de `library_v2` (mapping incluant `edition` et `popularity_tag`) :**

**Requête :**

```
PUT /library_v2
{
  "mappings": {
    "properties": {
      "title": { "type": "text", "analyzer": "standard" },
      "author": { "type": "keyword" },
      "publication_year": { "type": "date", "format": "yyyy||u" },
      "genre": { "type": "keyword" },
      "rating": { "type": "float" },
      "availability": { "type": "keyword" },
      "@timestamp": { "type": "date" },
      "popularity_tag": { "type": "keyword" },
      "edition": { "type": "keyword" }
    }
  }
}
```

**Résultat :**

```json
{
    "acknowledged": true,
    "shards_acknowledged": true,
    "index": "library_v2"
}
```

**Étape 2 — Reindex avec ajout de `edition` :**

**Requête :**

```
POST /_reindex
{
  "source": { "index": "library" },
  "dest":   { "index": "library_v2" },
  "script": {
    "lang": "painless",
    "source": "ctx._source.edition = 'Original'"
  }
}
```

**Résultat :**

```json
{
    "took": 49,
    "timed_out": false,
    "total": 20,
    "updated": 0,
    "created": 20,
    "deleted": 0,
    "batches": 1,
    "version_conflicts": 0,
    "noops": 0,
    "retries": {
        "bulk": 0,
        "search": 0
    },
    "throttled_millis": 0,
    "requests_per_second": -1.0,
    "throttled_until_millis": 0,
    "failures": []
}
```

**Vérification — un document de `library_v2` :**

**Résultat :**

```json
{
  "_index" : "library_v2",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "publication_year" : "1965",
    "@timestamp" : "2024-09-30T10:00:00Z",
    "author" : "Frank Herbert",
    "genre" : "Science Fiction",
    "rating" : 4.8,
    "edition" : "Original",
    "availability" : "Available",
    "title" : "Dune",
    "popularity_tag" : "Popular"
  }
}
```

---

## 9. Transformation *pivot* — nombre de livres disponibles par genre

**Requête :**

```
PUT /_transform/books_available_by_genre
{
  "source": {
    "index": "library",
    "query": { "term": { "availability": "Available" } }
  },
  "pivot": {
    "group_by": {
      "genre": { "terms": { "field": "genre" } }
    },
    "aggregations": {
      "available_books": { "value_count": { "field": "genre" } }
    }
  },
  "dest": { "index": "books_available_by_genre" }
}
```

**Résultat :**

```json
{
    "acknowledged": true
}
```

**Démarrage :** `POST /_transform/books_available_by_genre/_start` — puis résultat de l'index de destination :

**Requête :**

```
GET /books_available_by_genre/_search
```

**Résultat :**

```json
{
  "hits" : {
    "hits" : [
      {
        "_source" : {
          "genre" : "Epic",
          "available_books" : 1
        }
      },
      {
        "_source" : {
          "genre" : "Fantasy",
          "available_books" : 2
        }
      },
      {
        "_source" : {
          "genre" : "Fiction",
          "available_books" : 4
        }
      },
      {
        "_source" : {
          "genre" : "Historical Fiction",
          "available_books" : 2
        }
      },
      {
        "_source" : {
          "genre" : "Horror",
          "available_books" : 2
        }
      },
      {
        "_source" : {
          "genre" : "Philosophical Fiction",
          "available_books" : 1
        }
      },
      {
        "_source" : {
          "genre" : "Romance",
          "available_books" : 1
        }
      },
      {
        "_source" : {
          "genre" : "Science Fiction",
          "available_books" : 1
        }
      }
    ]
  }
}
```

---

## 10. Transformation *latest* — dernier livre publié par auteur

**Requête :**

```
PUT /_transform/latest_book_per_author
{
  "source": { "index": "library" },
  "latest": {
    "unique_key": [ "author" ],
    "sort": "publication_year"
  },
  "dest": { "index": "latest_book_per_author" }
}
```

**Résultat :**

```json
{
    "acknowledged": true
}
```

**Démarrage :** `POST /_transform/latest_book_per_author/_start` — puis résultat de l'index de destination :

**Requête :**

```
GET /latest_book_per_author/_search
```

**Résultat :**

```json
{
  "hits" : {
    "hits" : [
      {
        "_source" : {
          "publication_year" : "1932",
          "@timestamp" : "2024-09-30T14:00:00Z",
          "author" : "Aldous Huxley",
          "genre" : "Dystopian",
          "rating" : 4.5,
          "availability" : "Checked Out",
          "title" : "Brave New World",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1897",
          "@timestamp" : "2024-09-30T23:00:00Z",
          "author" : "Bram Stoker",
          "genre" : "Horror",
          "rating" : 4.4,
          "availability" : "Checked Out",
          "title" : "Dracula",
          "popularity_tag" : "Regular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1925",
          "@timestamp" : "2024-09-30T15:00:00Z",
          "author" : "F. Scott Fitzgerald",
          "genre" : "Fiction",
          "rating" : 4.4,
          "availability" : "Available",
          "title" : "The Great Gatsby",
          "popularity_tag" : "Regular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1965",
          "@timestamp" : "2024-09-30T10:00:00Z",
          "author" : "Frank Herbert",
          "genre" : "Science Fiction",
          "rating" : 4.8,
          "availability" : "Available",
          "title" : "Dune",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1880",
          "@timestamp" : "2024-10-01T03:00:00Z",
          "author" : "Fyodor Dostoevsky",
          "genre" : "Philosophical Fiction",
          "rating" : 4.9,
          "availability" : "Checked Out",
          "title" : "The Brothers Karamazov",
          "popularity_tag" : "Best Seller"
        }
      },
      {
        "_source" : {
          "publication_year" : "1949",
          "@timestamp" : "2024-09-30T11:00:00Z",
          "author" : "George Orwell",
          "genre" : "Dystopian",
          "rating" : 4.6,
          "availability" : "Checked Out",
          "title" : "1984",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1960",
          "@timestamp" : "2024-09-30T13:00:00Z",
          "author" : "Harper Lee",
          "genre" : "Fiction",
          "rating" : 4.9,
          "availability" : "Available",
          "title" : "To Kill a Mockingbird",
          "popularity_tag" : "Best Seller"
        }
      },
      {
        "_source" : {
          "publication_year" : "1851",
          "@timestamp" : "2024-09-30T16:00:00Z",
          "author" : "Herman Melville",
          "genre" : "Fiction",
          "rating" : 4.1,
          "availability" : "Available",
          "title" : "Moby Dick",
          "popularity_tag" : "Regular"
        }
      },
      {
        "_source" : {
          "publication_year" : "-800",
          "@timestamp" : "2024-10-01T01:00:00Z",
          "author" : "Homer",
          "genre" : "Epic",
          "rating" : 4.7,
          "availability" : "Available",
          "title" : "The Odyssey",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1951",
          "@timestamp" : "2024-09-30T18:00:00Z",
          "author" : "J.D. Salinger",
          "genre" : "Fiction",
          "rating" : 4.3,
          "availability" : "Available",
          "title" : "The Catcher in the Rye",
          "popularity_tag" : "Regular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1997",
          "@timestamp" : "2024-09-30T20:00:00Z",
          "author" : "J.K. Rowling",
          "genre" : "Fantasy",
          "rating" : 4.7,
          "availability" : "Checked Out",
          "title" : "Harry Potter and the Philosopher's Stone",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1954",
          "@timestamp" : "2024-09-30T19:00:00Z",
          "author" : "J.R.R. Tolkien",
          "genre" : "Fantasy",
          "rating" : 4.9,
          "availability" : "Available",
          "title" : "The Lord of the Rings",
          "popularity_tag" : "Best Seller"
        }
      },
      {
        "_source" : {
          "publication_year" : "1813",
          "@timestamp" : "2024-09-30T17:00:00Z",
          "author" : "Jane Austen",
          "genre" : "Romance",
          "rating" : 4.9,
          "availability" : "Checked Out",
          "title" : "Pride and Prejudice",
          "popularity_tag" : "Best Seller"
        }
      },
      {
        "_source" : {
          "publication_year" : "1877",
          "@timestamp" : "2024-10-01T04:00:00Z",
          "author" : "Leo Tolstoy",
          "genre" : "Romance",
          "rating" : 4.7,
          "availability" : "Available",
          "title" : "Anna Karenina",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1818",
          "@timestamp" : "2024-09-30T22:00:00Z",
          "author" : "Mary Shelley",
          "genre" : "Horror",
          "rating" : 4.5,
          "availability" : "Available",
          "title" : "Frankenstein",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1977",
          "@timestamp" : "2024-09-30T21:00:00Z",
          "author" : "Stephen King",
          "genre" : "Horror",
          "rating" : 4.6,
          "availability" : "Available",
          "title" : "The Shining",
          "popularity_tag" : "Popular"
        }
      },
      {
        "_source" : {
          "publication_year" : "1862",
          "@timestamp" : "2024-10-01T05:00:00Z",
          "author" : "Victor Hugo",
          "genre" : "Historical Fiction",
          "rating" : 4.9,
          "availability" : "Available",
          "title" : "Les Misérables",
          "popularity_tag" : "Best Seller"
        }
      }
    ]
  }
}
```

---

