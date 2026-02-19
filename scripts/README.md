# Scripts d'optimisation d'images

Scripts pour gérer l'optimisation des images du site DevFest (conversion JPG/PNG → WebP).

Voir aussi : [README principal](../README.md)

## Principe

**Les images sources (JPG/PNG) sont supprimées après conversion en WebP.** L'audit vérifie qu'aucune référence à JPG/PNG ne reste dans le code.

## Scripts

### 1. `optimize-images.sh`
Script principal de conversion. Convertit JPG/PNG en WebP (qualité 85).

```bash
# Mode sûr - convertit mais garde les fichiers sources
./scripts/optimize-images.sh

# Mode complet - convertit, remplace les URLs et SUPPRIME les fichiers sources
./scripts/optimize-images.sh --full

# Audit uniquement
./scripts/optimize-images.sh --audit
```

### 2. `audit-images.sh`
Vérificateur d'intégrité des références. **Bloque les commits** avec des références JPG/PNG.

```bash
./scripts/audit-images.sh
```

**Vérifications :**
- Références JPG/PNG dans les fichiers sources (**BLOQUANT**)
- Références à des fichiers manquants (**BLOQUANT**)
- Fichiers WebP orphelins (avertissement)

**Codes de sortie :**
- `0` = Tout est OK
- `1` = Problèmes bloquants détectés

## Flux de travail

### Conversion d'images

```bash
# 1. Convertir (mode sûr)
./scripts/optimize-images.sh

# 2. Vérifier
./scripts/audit-images.sh

# 3. Mode complet (supprime les sources)
./scripts/optimize-images.sh --full
```

## Dépannage

### "cwebp failed, trying ImageMagick..."

Certains JPEG ont des profils colorimétriques inhabituels. Le script utilise ImageMagick en fallback automatiquement.

### Fichiers sources conservés après --full

Les fichiers sources ne sont supprimés que si :
1. Le WebP a été créé avec succès
2. Le WebP est non-vide
3. Le WebP est plus récent que la source

## Installation des dépendances

```bash
sudo apt-get install webp imagemagick
```
