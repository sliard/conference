---
layout: devfestnoz_conference
permalink: /
url: https://devfestnoz.codedarmor.fr/
logo_url: "/assets/2026/devfestnoz/logo_dark.png"
footer_logo_url: "/assets/2026/devfestnoz/logo_light.png"

title: "DevFestNoz - 12 Mars 2026 - Lannion"
thumbnail_url: /assets/2024/devfestnoz/assets/img/social-card/social-card-devfestnoz-2023.png

Carrousel_Slides:
  - logo: /assets/2024/devfestnoz/assets/img/logo_light.png
    title: DevFestNoz 2026
    subtitle: "OCaml - CI/CD"
    subtitle2: 12 mars 2026 - 18h00 - Lannion
    image:
      url: /assets/2026/devfestnoz/carousel-bg.jpg
      alt: "DevFestNoz 2026"
    button1:
      isPrimary: True
      isExternal: True
      isContrasted: True
      text: Inscription gratuite
      target: _blank
      url: https://www.billetweb.fr/soiree-devfestnoz-2026
    button2:
      isPrimary: False
      isExternal: False
      isContrasted: True
      text: Programme
      target: _self
      url: "#agenda"

Details:
  where:
    venue: Maison des Entreprises - Espace Corinne Erhel
    address: 4 Rue Louis de Broglie
    city: 22300 Lannion
    linkToMap: https://www.google.com/maps/search/4+Rue+Louis+de+Broglie+22300+Lannion
  when:
    date: 12 mars 2026
    time: de 18h00 à 20h30
  who:
    attendees: Ouvert à toutes et tous
    limit: dans la limite des places disponibles
  cocktail:
    whatOffered: Networking et échanges
    callToAction: rejoignez la communauté tech trégorroise
  what:
    title: "Edito"
    description: |
      <p>L'écosystème du développement traverse une période de transformations profondes. D'un côté, <strong>l'intelligence artificielle générative redéfinit notre capacité à produire du code</strong> : ce qui prenait des semaines peut désormais être généré en quelques minutes. De l'autre, nos infrastructures cloud deviennent exponentiellement complexes, multipliant les couches d'abstraction entre intention et déploiement.</p>
      <p>Cette accélération vertigineuse révèle <strong>une fracture critique entre production et vérification</strong> : nous savons produire du code à une échelle inédite, mais nos mécanismes de vérification, de revue et d'observabilité peinent à suivre le rythme. Comment garantir la qualité quand chaque développeur devient potentiellement un "10x engineer", mais qu'aucun reviewer ne peut absorber ce volume ? Comment s'assurer qu'une application est réellement opérationnelle quand les systèmes de déploiement automatisé masquent la réalité de l'état des ressources ?</p>
      <p>Cuihtlauac Alvarado explorera pourquoi <strong>les langages fonctionnels sont mieux armés face à la crise de la vérification logicielle</strong> à l'ère de l'IA générative. Mathieu Laude décortiquera les health checks d'Argo CD pour transformer vos déploiements Kubernetes en indicateurs fiables de l'état réel de vos applications.</p>

Register:
  title: Inscription
  text: "L'événement est gratuit mais l'inscription est obligatoire pour des raisons d'organisation."
  button1:
    isPrimary: True
    isExternal: True
    isContrasted: True
    text: S'inscrire
    target: _blank
    url: https://www.billetweb.fr/soiree-devfestnoz-2026

Agenda:
  title: Programme
  schedule:
    - slot_begin_time: "18h00"
      slot_type: break
      title: Accueil et networking
      description: Arrivée des participants, café et discussions informelles
      speakers: []
    - slot_begin_time: "18h30"
      slot_type: talk
      title: "Quand la revue de code ne passe plus à l'échelle"
      description: >
        Les IA permettent désormais de générer d'immenses quantités de code complexe. Garantir la qualité du code, c'était soit très cher, soit très lent. Ça devient impossible. "Everyone is a 10x engineer; nobody is a 10x reviewer." Très peu de technologies peuvent surmonter cette fracture. Dans ce contexte, le prisme par lequel on compare les langages n'est plus le même. J'esquisserai pourquoi les langages fonctionnels sont mieux équipés pour faire face à la crise de la vérification logicielle.
      speakers:
        - id: cuihtlauac
    - slot_begin_time: "19h15"
      slot_type: break
      title: Pause et échanges
      description: Moment de convivialité pour échanger avec les speakers et les autres participants
      speakers: []
    - slot_begin_time: "19h30"
      slot_type: talk
      title: "Une plongée dans le fonctionnement des health checks Argo CD"
      description: >
        Découvrez ce qui se cache derrière le cœur vert d'Argo CD : les ressources supportées, les règles d'évaluation du bon déploiement de différents objets, les états possibles. Nous verrons ensuite les limites de ce mécanisme et comment personnaliser les règles d'évaluation de l'état de santé de vos objets Kubernetes.
        Vos applications seront ainsi plus finement observables et Argo CD deviendra un pilote GitOps plus pertinent pour vos ressources CRD ou opérateurs spécifiques.
      speakers:
        - id: mathieu_laude
    - slot_begin_time: "20h15"
      slot_type: break
      title: Conclusion, apéro et networking
      description: Clôture de la soirée, début de l'apéro et derniers échanges
      speakers: []

Speakers:
  title: Speakers
  list:
    - name: "Cuihtlauac Alvarado"
      id: "cuihtlauac"
      organization: "Tarides"
      photo_url: "assets/2026/devfestnoz/speakers/cuihtlauac.webp"
      bio: >
        Ingénieur logiciel senior chez Tarides. Docteur en informatique. Des expériences diversifiées : programmation fonctionnelle, applications mobiles, sécurité informatique, standardisation.
      social_links:
        - type: linkedin
          url: https://www.linkedin.com/in/cuihtlauac-alvarado/
        - type: github
          url: https://github.com/cuihtlauac
    - name: "Mathieu Laude"
      id: "mathieu_laude"
      organization: ""
      photo_url: "assets/2026/devfestnoz/speakers/mathieu.webp"
      bio: >
        En tant qu'ingénieur Full Stack avec plus de 15 ans d'expérience, je contribue à automatiser et optimiser le déploiement d'applications de mes différents clients. Je suis également formateur Docker et Kubernetes, outils souvent utiles pour les équipes qui veulent aller plus vite du POC à la prod.
      social_links: []

Newsletter:
  title: "Restez informé des prochaines actus Code d'Armor"
  description: "Si vous souhaitez en savoir plus sur Code d'Armor et être averti des prochains événements organisés par l'association et de ses actualités 👇️"
  cta: "S'inscrire à la newsletter"
  ctaLinkedIn: "Suivre la page LinkedIn"
---
