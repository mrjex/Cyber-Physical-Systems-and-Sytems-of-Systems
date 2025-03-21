# References used to verfiy the LLMs answers

## Reference 1

Zerouali, Ahmed. Analyzing Technical Lag in Alpine Docker Images. III. Method. Page 2.
https://www.researchgate.net/profile/Ahmed-Zerouali-2/publication/331683150_Analyzing_Technical_Lag_in_Docker_Images/links/5c87b38492851c831974edd2/Analyzing-Technical-Lag-in-Docker-Images.pdf (Retrieved 08-04-2024)

Key quote that is aligned with the LLMs output:

"Because of Alpine’s widespread
use in Docker Hub we chose to locally mirror and analyze
Docker images that rely on Alpine’s lightweight base image3
.
Alpine has a quite simple and good package manager that is
attracting people to migrate their images to it [10]."

## Reference 2 
Text

Christensen, Gabrielle. etc. The LLM-Based Mini-Lecture Generation for Enhanced Learning Project, Features Implemented,
Installation Instructions. https://cs-courses.mines.edu/csci370/FS2023F/FinalReport/FinalReport_HiLabs1.pdf (Retrieved 08-04-2024)

combined with

README.md, https://github.com/ollama/ollama (Retrieved 08-04-2024)

Rationale:
    * A reliable source that thoroughly outlines how to use and install a digital tool is always
      a green flag. Tools without installation procedures most likely lack external packages (which implies
      that the tool can\t be that complicated. In this case, when working with a LLM that tend to be
      more complex due to their necessity of retrieving gigantic volumes of external data, neglecting
      external dependencies is suspicious)