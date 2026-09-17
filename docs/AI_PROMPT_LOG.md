// filepath: docs/AI_PROMPT_LOG.md

## AI awareness (15 points)

This section summarizes the major AI interactions in the project, the decision points, and the cases where the AI suggestions had to be modified or rejected. The goal is to show that the generated ideas were not followed blindly, but were reviewed, refined, and aligned with the project requirements.

### 1) Prompt log – significant AI interactions

| # | Prompt / goal | Short summary of AI response | Project result |
|---|---|---|---|
| 1 | Planning routing and navigation between the main screens | Suggested a GoRouter-based route structure with separate login/registration/home/services/booking paths. | Navigation gained a stable foundation with distinct routes and named calls. |
| 2 | Creating the registration screen | Created the registration UI fields, password confirmation, and a back link to the login page. | The `RegistrationScreen` was created and fits the sign-in flow. |
| 3 | Expanding the home screen content | Suggested a hero section, info cards, and a services button. | The home page became more informative and gained a direct entry point to the service list. |
| 4 | Designing the service list grid layout | Recommended a vertical card structure and a 2-column grid while keeping small screens in mind. | The `ServiceGridCard` and grid layout were created to use space more effectively. |
| 5 | Fixing overflow issues in the grid cards | Suggested padding, font-size, and `childAspectRatio` adjustments to reduce overflow. | The service cards became more stable on smaller screens. |
| 6 | Adding search and sorting to the service list | Recommended adding a search field and sorting by name/price. | The list became more usable and the user could find services faster. |
| 7 | Accessibility improvements | Suggested `semanticsLabel`, better heading structure, and contrast checks. | The UI became more readable and more usable with screen readers. |
| 8 | Documenting the Firestore data model | Requested a clear description of the collections and relationships in the documentation. | `DATAMODEL.md` now reflects the users/services/categories/appointments structure more accurately. |
| 9 | Error page and route error handling | Suggested an `ErrorScreen` and `errorBuilder` configuration for unknown routes. | Invalid URLs are handled cleanly, and users can return to the main page. |
| 10 | Score calculation and compliance evaluation | Provided a summary assessment of the implementation and documentation. | Helped identify remaining gaps relative to the project requirements. |

### 2) Decision-making – accepted / modified / rejected

| Decision | What happened? | Reason | Impact |
|---|---|---|---|
| Accepted | The GoRouter-based route structure remained. | It was clear, named, and easy to extend. | Navigation became more stable and the flow was easier to follow. |
| Modified | The original layout of the service cards had to be refined. | The first version was too tight and risked overflow on smaller screens. | Smaller font sizes, better padding, and a more suitable aspect ratio were introduced. |
| Accepted | Search and sorting were added to the list page. | These provide real user value and fit well with the mock data. | Usability improved and the page became more interactive. |
| Modified | The AI-generated UI text and labels were rewritten in several places. | They had to match the project tone and the Hungarian-language interface. | More consistent and natural user-facing text was produced. |
| Accepted | Accessibility improvements were implemented. | They improved quality and evaluation potential with minimal code changes. | Accessibility improved and the development process became more conscious and documentable. |

### 3) Critical perspective – AI mistakes and their fixes

| Case | What was the problem? | How was it fixed? |
|---|---|---|
| 1 | The AI initially suggested too large a card size / overly optimistic layout for the service grid. | The layout was toned down: smaller padding, a suitable `childAspectRatio`, smaller text, and min-size adjustments were added. |
| 2 | Some AI-generated texts and labels were not fully consistent or natural in Hungarian. | They were rewritten for language and UX consistency so the interface would feel more coherent. |

### 4) Critical thinking – what we checked

- We compared the generated route names and navigation calls with the actual screens.
- We refined the grid layout responsively so it would work not only in theory.
- We aligned the documentation with the actual file structure (`DATAMODEL.md`, `ErrorScreen`, `go_router`).
- For accessibility updates, we considered not just the code but also the user experience.

### 5) Overall assessment

The AI was used as a design accelerator and review tool, not as an unquestioned source of truth. The combination of generated proposals and manual validation helped produce a more structured, user-friendly, and better-documented project outcome.

---

