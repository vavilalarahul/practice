# SET-7 — Sports Management System

> **Exam order:** Git/GitHub → Maven → Docker.\
**Actual question name (short):** Sports Management
> Repository: `https://github.com/sarasrija/SportManagementSystem.git`

## PART I --- GIT & GITHUB (40M)

### 1. Clone / set up locally

``` bash
git clone https://github.com/sarasrija/SportManagementSystem.git
cd SportManagementSystem
```

### 2. Verify remote

``` bash
git remote -v
```

### 3. Inspect status

``` bash
git status
```

### 4. Create and switch to feature branch

``` bash
git switch -c feature/player-registration
```

### 5. Show local + remote branches and current branch

``` bash
git branch -a
git branch --show-current
```

### 6. Commit `RegistrationServlet.java`

``` bash
git add src/main/java/com/sports/servlet/RegistrationServlet.java
git commit -m "Add player registration servlet"
```

### 7. Add forgotten `web.xml` to previous commit without changing message

``` bash
git add src/main/webapp/WEB-INF/web.xml
git commit --amend --no-edit
```

### 8. Fetch remote updates without modifying working files

``` bash
git fetch origin
```

### 9. Incorporate latest remote main into current branch

``` bash
git merge origin/main
```

### 10. Rebase feature branch onto updated main

``` bash
git rebase origin/main
```

### 11. Cancel rebase

``` bash
git rebase --abort
```

### 12. Safely undo bad test commit

``` bash
git revert <BAD_COMMIT_HASH>
```

### 13. Undo last commit but keep changes staged

``` bash
git reset --soft HEAD~1
```

### 14. Remove committed `db-config.env` from Git but keep local file

``` bash
git rm --cached src/main/resources/db-config.env
```

Then prevent future tracking by adding it to `.gitignore`.

### 15. Stash unfinished `schedule.jsp`

``` bash
git stash
```

### 16. View and restore stash

``` bash
git stash list
git stash pop
```

### 17. Compare feature and main for `index.jsp`

``` bash
git diff main...feature/player-registration -- src/main/webapp/index.jsp
```

### 18. Compact visual branch timeline

``` bash
git log --oneline --graph --decorate --all
```

### 19. Merge feature into main

``` bash
git switch main
git merge feature/player-registration
```

### 20. Push and verify exact commit point

``` bash
git push origin main
git fetch origin
git status
```

Optional exact commit comparison:

``` bash
git rev-parse HEAD
git rev-parse origin/main
```

If both hashes are identical, local main and remote main point to the
same commit.

------------------------------------------------------------------------

## PART II --- MAVEN (40M)

### 1. Validate POM

**POM FILE NOTE:** No complete/corrected `pom.xml` was supplied for this set in the source material. Do **not** use the POM from another set. Use the POM supplied in the exam/project repository.

``` bash
mvn validate
```

If Maven reports a malformed dependency, fix the XML structure and
required dependency fields in `pom.xml`.

### 2. Tomcat Maven plugin

The paper asks for the complete corrected `<plugin>` block for
`tomcat7:run`. Use the exact plugin coordinates/version expected by the
supplied POM/question; do not invent coordinates if the exam provides
them.

Then run:

``` bash
mvn tomcat7:run
```

### 3. Database dependency failure

Inspect:

``` bash
mvn dependency:tree
```

Check/fix the database dependency's:

``` text
groupId
artifactId
version
```

Then:

``` bash
mvn clean compile
```

### 4. Test dependency missing element

Check the dependency in `pom.xml` and supply its required version.

Then:

``` bash
mvn test-compile
```

### 5. Exact WAR filename

The output filename follows the Maven build naming rule and any
configured:

``` xml
<finalName>...</finalName>
```

Check:

``` bash
dir target
```

### 6. Context path

If a Maven web-server plugin supplies a configured context path, use
that exact configured value. Otherwise, for a WAR deployed under Tomcat,
the context path normally follows the deployed WAR name.

### 7. `pluginManagement` vs `plugins`

``` text
pluginManagement → stores plugin configuration/defaults; does not itself activate execution.
plugins           → declares plugins used by the build.
```

### 8. SNAPSHOT

Example:

``` xml
<version>0.0.1-SNAPSHOT</version>
```

`SNAPSHOT` denotes an in-development version rather than a final
release.

### 9. Maven JDK version

``` bash
mvn -version
```

### 10. Clean + package + full debug log

``` bash
mvn clean package -X
```

### 11. Install vendor JAR

Use the exact coordinates specified by the question/POM:

``` bash
mvn install:install-file -Dfile=sports-analytics.jar -DgroupId=<groupId> -DartifactId=<artifactId> -Dversion=<version> -Dpackaging=jar
```

### 12. Dependency tree

``` bash
mvn dependency:tree
```

### 13. Test output locations

``` text
target/test-classes/
target/surefire-reports/
```

### 14. Run one test

``` bash
mvn -Dtest=TournamentBracketTest test
```

### 15. Package even when tests fail

``` bash
mvn package -DskipTests
```

### 16. Find unused declared dependencies

``` bash
mvn dependency:analyze
```

### 17. Servlet API `provided`

``` xml
<scope>provided</scope>
```

Tomcat supplies the Servlet API at runtime, so Maven should not package
another copy into the application.

------------------------------------------------------------------------

## PART III --- DOCKER

### 1. Clone / enter / inspect project

``` bash
git clone https://github.com/sarasrija/SportManagementSystem.git
cd SportManagementSystem
dir
```

### 2. Dockerfile

``` dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/sports-management.jar .

CMD ["java", "-jar", "sports-management.jar"]
```

If the actual artifact is a WAR and the question requires Tomcat, use a
Tomcat runtime instead.

### 3. Build image

``` bash
docker build -t sportsapp-image .
```

### 4. Run container on 8080

``` bash
docker run -d --name sports-app-container -p 8080:8080 sportsapp-image
```

### 5. Running containers

``` bash
docker ps
```

### 6. All containers

``` bash
docker ps -a
```

### 7. Enter container

``` bash
docker exec -it sports-app-container /bin/bash
```

### 8. Stop and restart

``` bash
docker stop sports-app-container
docker start sports-app-container
```

### 9. Save container state as image

``` bash
docker commit 0e993d2009a1 <dockerhub-username>/sportsapp:v1
```

### 10. Docker Hub login

``` bash
docker login
```

### 11. Push

``` bash
docker push <dockerhub-username>/sportsapp:v1
```

### 12. Logout

``` bash
docker logout
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/sarasrija/SportManagementSystem.git
cd SportManagementSystem
git status
git branch -a

mvn validate
mvn dependency:tree
mvn clean package

docker build -t sportsapp-image .
docker run -d --name sports-app-container -p 8080:8080 sportsapp-image
docker ps
docker logs sports-app-container
```
