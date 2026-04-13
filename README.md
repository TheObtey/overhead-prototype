# OverHead Prototype (on Godot)

## Contexte du projet

Ce prototype s’inscrit dans le cadre du **GPC (Grand Projet Commun)**.
L’objectif est de développer un **premier prototype jouable sous Godot**, en attendant la finalisation du moteur custom nodal.

Le jeu est un **puzzle FPS coopératif à deux joueurs**, jouable en local ou en ligne, fortement inspiré de Portal dans sa structure (résolution de salles).
La mécanique centrale du projet repose sur la **manipulation de la gravité**, avec des zones possédant différentes orientations gravitationnelles.

Exemple typique : une salle où le sol et le plafond ont des gravités opposées → deux joueurs évoluent simultanément dans des référentiels différents.

------

## Objectif du prototype

Ce prototype n’a pas vocation à être un jeu final, mais un **terrain d’expérimentation gameplay**.

Il doit permettre de :

- Tester les mécaniques de gravité (zones, transitions, interactions)
- Valider les 3C
- Expérimenter la coopération entre deux joueurs
- Définir des patterns de level design
- Préparer une base réutilisable pour le moteur custom

------

## Architecture globale

Le projet repose sur une architecture **modulaire et découplée**, inspirée d’une logique component-based.

```
Player
 ├── MovementComponent
 ├── CameraComponent
 ├── InteractionComponent
 ├── InventoryComponent
 ├── EquipmentComponent
 └── GravityReceiverComponent

EntityBase
 ├── DoorEntity
 ├── ButtonEntity
 ├── PickupEntity
 └── PhysicsObjects (carryable)

Items
 ├── ItemBase
 ├── EquippableItemBase
 └── GravityGun

GravitySystem
 ├── GravityField (zones)
 └── GravityReceiver (player + objets)

Network
 └── NetworkManager (host / join / sync)
```

---

## Organisation des fichiers (TRÈS IMPORTANT)

Cette section est critique.
Le but est d’éviter le chaos dans le projet.

👉 **Personne ne crée de fichiers “au hasard” dans le projet.**

```
res://
|
+-- autoload/
|   → Managers globaux (Network, GameManager, etc.)
|
+-- scenes/
|   |
|   +-- main/
|   |   → scènes principales (menu, lobby, niveaux)
|   |
|   +-- player/
|   |   → Player + ses composants
|   |   |
|   |   +-- components/
|   |       → tous les scripts liés au player uniquement
|   |
|   +-- entities/
|   |   → toutes les entités interactives
|   |   |
|   |   +-- interactables/
|   |       → portes, boutons, objets interactifs
|   |
|   +-- items/
|   |   → tous les items (GravityGun, etc.)
|   |
|   +-- gravity/
|   |   → système de gravité (fields, system)
|   |
|   +-- ui/
|   |   → HUD, menus, inventaire UI
|   |
|   +-- props/
|       → objets visuels / tests (cubes, etc.)
|
+-- scripts/
|   |
|   +-- core/
|   |   → interfaces / contrats (Interactable, Carryable…)
|   |
|   +-- data/
|       → structures de données (ItemData, etc.)
|
+-- assets/
	→ modèles, textures, sons
```

---

## Règles à respecter ABSOLUMENT

Si tu bosses sur le projet, retiens ça :

### 1. Chaque fichier a UNE place logique

- Un script player → `scenes/player/`
- Un composant player → `scenes/player/components/`
- Une entité → `scenes/entities/`
- Un item → `scenes/items/`
- Un système global → `autoload/`

👉 Si tu hésites → demande avant de créer

### 2. Interdiction de créer des dossiers random

❌ Mauvais :

```
res://scripts/test/
res://new_stuff/
res://player_v2/
```

✅ Bon :

```
res://scenes/player/components/
res://scenes/entities/interactables/
```

### 3. Une feature = un endroit clair

Exemple :

- Tu ajoutes un bouton → `entities/interactables/`
- Tu ajoutes une arme → `items/`
- Tu modifies la gravité → `gravity/`

👉 Si ton code touche plusieurs systèmes → c’est probablement mal conçu

### 4. Ne mélange pas les responsabilités

- ❌ Player qui gère la gravité directement
- ❌ Item qui modifie le réseau
- ❌ Entity qui gère l’inventaire

👉 Chaque système doit rester à sa place

### 5. Respect de la hiérarchie scenes/scripts

- Les `.tscn` vont dans `scenes/`
- Les scripts “métier global” vont dans `scripts/`
- Les données vont dans `scripts/data/`

------

## Philosophie d’architecture

Le projet suit quelques principes forts :

### 1. Composition > Héritage

On évite les classes monolithiques.
Un `Player` est une **assemblage de composants**, pas un bloc rigide.

### 2. Découplage maximal

Chaque système est indépendant :

- Le player ne connaît pas les détails des objets
- Les objets ne connaissent pas le réseau
- La gravité est un système global isolé

### 3. Responsabilité unique

Chaque script fait **une seule chose** :

- MovementComponent → gérer les déplacements
- InventoryComponent → gérer le stockage d’items
- GravitySystem → appliquer la gravité

------

## Player

Le joueur est une entité composée de plusieurs composants :

- **MovementComponent** → déplacement FPS
- **CameraComponent** → gestion de la caméra
- **InteractionComponent** → raycast + interaction avec le monde
- **InventoryComponent** → stockage des items
- **EquipmentComponent** → item actif (ex: Gravity Gun)
- **GravityReceiverComponent** → reçoit les effets des champs de gravité

⚠️ Le player ne doit jamais contenir de logique métier complexe directement.

------

## Système d’inventaire & équipement

Deux notions distinctes :

- **Inventaire** → stocke les items
- **Équipement** → item actuellement utilisé

Exemple :

- Le joueur possède un Gravity Gun dans l’inventaire
- Il peut l’équiper / déséquiper via une touche

👉 Ne jamais mélanger ces deux concepts.

------

## Gravity Gun

Le Gravity Gun est un **item équipable**.

Responsabilités :

- Attraper un objet
- Le maintenir à distance
- Le relâcher

👉 Toute la logique doit être contenue dans l’item, pas dans le joueur.

------

## Entités & interactions

Toutes les entités interactives héritent de `EntityBase`.

Exemples :

- portes
- boutons
- objets transportables
- triggers

Le player interagit via un système générique :

```
if entity.can_interact():
	entity.interact(player)
```

👉 Le player ne doit jamais connaître le type exact de l’entité.

------

## Système de gravité

Le système de gravité est central et doit rester **global et indépendant**.

### GravityField

- Zone définissant une gravité spécifique
- Peut override la gravité par défaut

### GravityReceiver

- Composant présent sur le player et les objets
- Applique la gravité actuelle

👉 La gravité ne doit JAMAIS être codée en dur dans le player.

------

## Réseau

Le `NetworkManager` gère :

- création de serveur (host)
- connexion à un serveur (client)
- synchronisation des joueurs

⚠️ Règles importantes :

- Le gameplay ne dépend pas du réseau
- Le réseau ne contient pas de logique gameplay
- Toute logique doit fonctionner en solo avant d’être synchronisée

------

## Bonnes pratiques (TRÈS IMPORTANT)

### 🚫 À éviter absolument

- Mettre toute la logique dans un seul script
- Faire communiquer directement deux systèmes non liés
- Hardcoder des comportements spécifiques
- Coupler gameplay et réseau
- Ajouter des dépendances circulaires

------

### ✅ À faire

- Utiliser des composants
- Passer par des interfaces ou méthodes génériques (`interact()`, etc.)
- Garder les scripts petits et lisibles
- Documenter les comportements non évidents
- Tester chaque système indépendamment

------

## Workflow recommandé

Quand tu ajoutes une feature :

1. Tu identifies le système concerné (player ? item ? entity ?)
2. Tu crées un composant ou une extension
3. Tu évites de modifier du code existant si possible
4. Tu testes en isolation
5. Tu intègres progressivement

------

## Philosophie prototype

Ce projet est un prototype, donc :

- On privilégie la **clarté** à l’optimisation
- On expérimente rapidement
- On accepte de jeter du code
- MAIS on garde une **architecture propre**

------

## Évolutions possibles

Cette base doit permettre d’ajouter facilement :

- nouveaux items
- nouvelles mécaniques de gravité
- nouveaux types d’énigmes
- interactions coop avancées

------

## Rappel important

Si tu te poses une question en dev, demande-toi :

> “Est-ce que ce que je fais va rendre le projet plus simple à faire évoluer… ou plus compliqué ?”

👉 Si c’est plus compliqué, revois ton approche.

Si tu ne sais pas où mettre ton fichier, demande-toi :

> "Est-ce que ça concerne le joueur, un objet, un item, la gravité ou le réseau ?"

👉 La réponse de donne directement le dossier.

------

## Conclusion

Ce prototype est une **fondation** pour le futur moteur custom.

Si on fait ça proprement :

- on gagne du temps
- on comprend mieux nos besoins
- on évite de tout refaire plus tard

Sinon… on va souffrir 😄

------
