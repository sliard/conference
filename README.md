# DevFest Perros-Guirec

Site web de la conférence **DevFest Perros-Guirec**, organisée par l'association Code d'Armor. Ce site est construit avec [Jekyll](https://jekyllrb.com/), un générateur de sites statiques en Ruby.

> **Note :** Tout le contenu du site (textes, descriptions, messages) doit être rédigée en **français**.

## Démarrage rapide

```shell
# Installer les dépendances
bundle install

# Lancer le serveur de développement
bundle exec jekyll serve --trace
# Site accessible sur http://localhost:4000
```

## Scripts d'optimisation

Le projet inclut des scripts pour gérer les images (conversion JPG/PNG → WebP).

### Commandes principales

```shell
# Convertir les images (mode sûr - garde les fichiers sources)
./scripts/optimize-images.sh

# Convertir, remplacer les URLs et supprimer les fichiers sources
./scripts/optimize-images.sh --full

# Vérifier l'intégrité des références d'images
./scripts/audit-images.sh
```

Pour plus de détails, voir [scripts/README.md](./scripts/README.md).

## Prérequis

- Ruby 2.5 ou supérieur
- Bundler (gestionnaire de dépendances Ruby)

## Installation

### 1. Installer Ruby et les dépendances système

```shell
apt-get install ruby-full build-essential zlib1g-dev
```

### 2. Configurer l'environnement Ruby

```shell
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### 3. Installer Jekyll et les dépendances du projet

```shell
gem install jekyll bundler
bundle install
```

## Démarrage rapide

Lancer le serveur de développement local :

```shell
bundle exec jekyll serve --trace
```

Le site est accessible à l'adresse http://localhost:4000

## Structure du projet

```
.
├── index.md                 # Page d'accueil (configuration principale)
├── _config.yml              # Configuration Jekyll
├── Gemfile                  # Dépendances Ruby
├── _includes/               # Fragments HTML réutilisables
│   ├── header.html
│   ├── footer.html
│   ├── agenda.html
│   └── speakers.html
├── _layouts/                # Templates de pages
│   ├── home_conference.html
│   └── sponsors.html
├── _data/
│   └── commons.yml          # Données partagées (menu, sponsors)
├── _sass/                   # Styles SCSS
├── assets/                  # Ressources statiques
│   ├── 2025/               # Édition 2025
│   │   └── photos_speakers/
│   └── img/
│       └── logos_sponsors/
├── archives.md              # Page d'archives
├── sponsors.md              # Page sponsoring
└── about_ca.md              # Page association Code d'Armor
```

## Architecture des données

Le contenu du site est réparti entre deux sources principales :

### 1. `index.md` (Front Matter YAML)

Contient les données spécifiques à l'édition courante :
- **Speakers** : Liste des intervenants avec bios et photos
- **Agenda** : Programme, créneaux horaires et descriptions
- **Carrousel_Slides** : Diapositives de la bannière d'accueil
- **Details** : Informations de l'événement (date, lieu, etc.)
- **Sponsoring** : Section partenaires
- **Register** : Boutons d'inscription/billetterie
- **Shop** : Section boutique (goodies)
- **Gallery** : Galerie photos

Les sections sont conditionnellement affichées dans le layout. Pour masquer une section, il suffit de la commenter ou de la supprimer du front matter.

### 2. `_data/commons.yml`

Contient les données partagées entre les pages :
- **menu** : Liens de navigation
- **Newsletter** : Configuration de l'inscription newsletter
- **Sponsors** : Logos des sponsors (utilisés dans le footer et autres pages)

## Personnaliser le contenu

### Ajouter un intervenant

Dans `index.md`, ajouter sous `Speakers.list` :

```yaml
Speakers:
  list:
    - name: "Prénom Nom"
      id: "nom_unique"
      organization: "Entreprise"
      photo_url: "assets/2025/photos_speakers/nom.webp"
      bio: >
        Description de l'intervenant...
      social_links:
        - type: linkedin
          url: https://linkedin.com/in/...
        - type: twitter
          url: https://twitter.com/...
```

### Ajouter un créneau à l'agenda

Dans `index.md`, ajouter sous `Agenda.schedule` :

```yaml
Agenda:
  schedule:
    - slot_begin_time: "09:00"
      slot_type: talk        # talk, quickie, ou break
      title: "Titre de la présentation"
      speakers:
        - id: nom_unique      # Référence le Speakers.list
      description: >
        Description du talk...
      room: "Salle principale"
```

### Activer/désactiver une section

Pour masquer une section (par exemple quand le CFP est fermé), commentez-la dans `index.md` :

```yaml
# CallForProposal:
#   title: "Call for Proposal"
#   ...
```

Ou supprimez-la complètement. Le layout vérifie la présence de la section avant de l'afficher.

## Déploiement

Le site est déployé automatiquement sur GitHub Pages via GitHub Actions (voir `.github/workflows/jekyll.yml`).

À chaque push sur la branche `master`, le workflow :
1. Construit le site avec Jekyll
2. Déploie le résultat sur GitHub Pages

### Build manuel

Pour générer le site localement (dans `_site/`) :

```shell
# Build de développement
bundle exec jekyll build

# Build de production
JEKYLL_ENV=production bundle exec jekyll build
```

## Bonnes pratiques

- Les photos des speakers doivent être placées dans `assets/2025/photos_speakers/`
- Les logos des sponsors vont dans `assets/img/logos_sponsors/`
- Les éditions précédentes sont archivées dans `assets/YYYY/`
- Utilisez les fragments dans `_includes/` pour éviter la duplication de code HTML
- Les données dynamiques (agenda, intervenants) sont centralisées dans `index.md`

## Optimisations de performance

Le site intègre plusieurs optimisations pour améliorer les temps de chargement et les scores Core Web Vitals :

### Optimisations implémentées

| Technique | Impact | Fichiers concernés |
|-----------|--------|-------------------|
| **CSS critique inline** | Réduction du First Contentful Paint | `_includes/header.html` |
| **Chargement async CSS** | Non-bloquant pour le rendu | `_includes/header.html` |
| **JavaScript différé** | Meilleur Time to Interactive | `_includes/footer.html` |
| **Lazy loading images** | Réduction de la bande passante | `_includes/speakers.html`, `_includes/gallery.html` |
| **Resource hints** | Préconnexion aux CDN | `_includes/header.html` |
| **Compression gzip** | Réduction de la taille des assets | `_config.yml` |
| **Exclusion des anciens assets** | Build plus rapide | `_config.yml` |

### Résultats

- **Taille du site** : 1.7 GB → 988 MB (42% de réduction)
- **Temps de build** : ~11s → ~7s (36% plus rapide)
- **Premier affichage** : Amélioré avec le CSS critique inline
- **Images** : Chargement paresseux pour les images hors écran

### Optimisation des images

Pour convertir automatiquement les images en WebP et créer des tailles responsives :

```shell
# Installer les dépendances
sudo apt-get install webp imagemagick

# Exécuter le script d'optimisation
./scripts/optimize-images.sh
```

Ce script convertit les JPEG/PNG en WebP (qualité 85%) et génère des tailles responsives (400w, 800w, 1200w) pour la galerie.

### Chargement des ressources

- **CSS** : Le CSS critique est inline dans le `<head>`. Le reste est chargé de manière asynchrone.
- **JavaScript** : Tous les scripts sont placés en fin de page avec l'attribut `defer`.
- **Images** : Les images utilisent `loading="lazy"` et `decoding="async"`.
- **Polices** : Les polices Google Fonts sont chargées avec `display=swap`.

### Maintenance

Lors de l'ajout de nouvelles sections avec des images :
1. Ajouter `loading="lazy"` pour les images hors écran
2. Ajouter `decoding="async"` pour le décodage non-bloquant
3. Spécifier les dimensions (`width`, `height`) pour éviter les décalages de layout
4. Utiliser `fetchpriority="high"` pour l'image LCP (largest contentful paint)

## Archivage des éditions

Lorsqu'une édition est terminée, archivez le site dans `assets/<dossier>/`.

### Installation

```shell
bundle install
```

### Utilisation

```shell
bundle exec archive 2025
```

Cela :
1. Génère le site dans `_site/`
2. Copie le contenu vers `assets/2025/`
3. Corrige les URLs (convertit `/assets/...` en relatifs)
4. Ajoute l'entrée dans `archives.md`

### Exemples

```shell
# Archive standard
bundle exec archive 2025
# → Crée assets/2025/

# Archive édition spéciale
bundle exec archive 2025-devfestnoz
# → Crée assets/2025-devfestnoz/
```
