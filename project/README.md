[![Pipeline](https://git.chalmers.se/courses/dit638/students/2024-group-14/badges/main/pipeline.svg)](https://git.chalmers.se/courses/dit638/students/2024-group-14/)

# 2024-group-14

## Required Tools
These are the tools that are required to build the project, ensure that they are present on your system by running the following commands and getting a valid output.
```
g++ --version
make --version
cmake --version
git --version
```

## Clone And Build
These are the steps to build the project
```git clone git@git.chalmers.se:courses/dit638/students/2024-group-14.git
mkdir build (inside the cloned directory)
cd build
cmake ..
make
./helloworld <num>
```

## Adding New Features
When adding new features members shall follow the following steps:

1. Create an issue that includes a user story along with a acceptance criteria and the necessary labels.

2. Create and associate a branch from the issue to ensure traceabillity.

3. Once the feature has been implemented, create a merge request and assign a reviewer other than yourself.

## Fixing Unintended behavior
1. Create an incident that includes a list of steps to reproduce the bug.

2. Include the set-up of the environment which the bug occured in.

3. Create and associate a branch from the incident to ensure traceabillity.

4. Once the bug has been fixed, and the criteria has been met, create a merge request and assign a reviewer other than yourself.

## Commit Message Structure
Commit messages shall be prepended by the corresponding issue number in order to trace the commit back to the issue.
e.g `#1 My commit` <br />
Commits unrelated to the source code or issues such as README and Wiki changes can be directly comitted to the main branch.
