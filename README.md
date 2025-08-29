# README

# Organisation du dépôt DevFest Perros-Guirec

Ce dépôt contient le site web de la conférence DevFest Perros-Guirec, construit avec Jekyll. Voici les principaux dossiers et fichiers pour faciliter la prise en main :

## Structure principale

- **index.md** : Page d’accueil, contient la configuration des intervenants, agenda, boutique, etc.
- **_config.yml** : Fichier de configuration principal pour Jekyll ou Hugo, définissant l’URL du site, le thème, les paramètres de la conférence (nom, date, lieu, prix), les sections actives, les sponsors, partenaires et le programme. Modifie ce fichier pour personnaliser le contenu et la structure du site. 
- **Gemfile / Gemfile.lock** : Liste et verrouille les dépendances Ruby nécessaires au fonctionnement de Jekyll. Assure la cohérence de l’environnement de développement et facilite l’installation des plugins.
- **_includes/** : Fragments HTML réutilisables (header, footer, agenda, boutons, etc.).
- **_layouts/** : Templates de pages (sponsors, home, etc.).
- **_data/** : Fichiers YAML pour les données partagées (ex : partenaires).
- **_sass/** : Fichiers de styles Sass pour la personnalisation CSS.
- **assets/** : Images, feuilles de style, scripts JS, et ressources statiques pour chaque édition.
- **archives.md** : Page d’archives des éditions précédentes.
- **sponsors.md** : Page dédiée au sponsoring.
- **about_ca.md** : Page “À propos” de l’association Code d’Armor.

## Données 
Les données sont réparties entre config.yml et /_data/commons.yml

### Sections de données dans `config.yml`

- **params**
    - Conference info (Name, Description, Date, Price, Venue, Address, City, State, Images, GoogleMapsKey)
    - Sections (about, location, speakers, schedule, sponsors, partners, contact)
    - Titles (about, location, speakers, schedule, sponsors, partners, contact)
    - CallToAction
    - ForkButton
    - Sponsors
    - Partners
    - Schedule

### Sections de données dans `_data/commons.yml`

- **logo_url**
- **menu**
- **Newsletter**
- **Sponsors**
    - logos_basic
    - logos_advanced

## Démarrage rapide

1. Installe les dépendances Ruby et Jekyll (voir [README.md](README.md)).
2. Lance le serveur local avec `bundle exec jekyll serve --trace`.
3. Modifie le contenu dans les fichiers markdown ou HTML selon la section du site à mettre à jour.

## Bonnes pratiques

- Utilise les fragments dans `_includes/` pour éviter la duplication de code HTML.
- Les données dynamiques (agenda, intervenants, partenaires) sont centralisées dans `index.md` ou `_data/`.
- Les ressources statiques (images, CSS, JS) sont rangées dans `assets/` par année ou usage.

Pour toute question, consulte le README ou demande

## Installer l'environnement

```shell
apt-get install ruby-full build-essential zlib1g-dev

echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

gem install jekyll bundler
bundle install
```

## Démarrer une instance locale

```shell
bundle exec jekyll serve --trace
```

