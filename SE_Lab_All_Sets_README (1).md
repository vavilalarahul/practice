# Software Engineering Lab Internal – All Sets Answer README

> **Purpose:** This is a practical, last-minute lab guide. It contains the questions from all uploaded papers, segregated by the **actual application/set appearing inside each paper**, with short answers and the exact commands/configuration you can type.
>
> **Important:** A few questions ask you to inspect a specific `pom.xml` and identify an **exact error, exact WAR filename, exact context path, or exact vendor-library coordinates**. Those details are **not printed in the question paper and the corresponding repository/POM is not included as an uploaded file**, so I have **not invented them**. For those, I give the exact method to obtain the answer during the lab.

---

# 0. 10-Minute Survival Guide

## Basic Maven flow

```bash
git clone <REPOSITORY_URL>
cd <PROJECT_FOLDER>

mvn clean
mvn validate
mvn dependency:tree
mvn compile
mvn test
mvn package
mvn clean install
```

Useful:

```bash
mvn clean package -DskipTests
mvn clean package -Dmaven.test.skip=true
mvn -version
mvn help:effective-pom
mvn dependency:analyze
```

- `clean` → deletes old `target/`
- `compile` → compiles main Java code
- `test-compile` → compiles tests
- `test` → runs tests
- `package` → creates JAR/WAR
- `install` → puts the built artifact in your local Maven repository

## Basic Git flow

```bash
git clone <URL>
cd <PROJECT>

git status
git add .
git commit -m "message"
git push -u origin main
```

Branches:

```bash
git switch -c feature/name
git switch main
git branch -a
git fetch origin
git pull origin main
git rebase origin/main
git merge feature/name
```

Undo:

```bash
git restore file.java                 # discard unstaged changes
git restore --staged file.java       # unstage, keep file changes
git revert <commit-id>               # safe undo with new commit
git reset --soft HEAD~1               # undo last commit, keep changes staged
git rm --cached secret.env            # stop tracking, keep local file
```

Temporary work:

```bash
git stash
git stash list
git stash pop
```

## Basic Docker flow

```bash
docker build -t myapp .
docker images
docker run -d --name myapp-container -p 8080:8080 myapp
docker ps
docker ps -a
docker logs myapp-container
docker exec -it myapp-container sh
docker stop myapp-container
docker rm myapp-container
docker push <username>/<repo>:tag
```

---

# 1. PAPER / SET 1 – METRO BOOKING SYSTEM

**Source file:** `Set-1 (2).docx`  
**Repository:** `https://github.com/anujyog1/MetroRepo.git`

The paper asks you to clone the Metro project, fix/build it with Maven, perform Git/GitHub tasks, and containerize it with Docker.

---

## Part I – Maven

### Q1. Clone the project

```bash
git clone https://github.com/anujyog1/MetroRepo.git
cd MetroRepo
```

Open the folder in Eclipse:

**Eclipse → File → Import → Existing Maven Projects → select project folder.**

---

### Q1.1 Resolve dependencies using `pom.xml`

First inspect:

```bash
mvn validate
mvn dependency:tree
```

If Maven reports a missing/incorrect dependency, open `pom.xml` and check:

```xml
<dependency>
    <groupId>...</groupId>
    <artifactId>...</artifactId>
    <version>...</version>
</dependency>
```

Then:

```bash
mvn clean install
```

---

### Q1.2 Build the project and generate WAR/JAR

```bash
mvn clean package
```

Check:

```bash
dir target
```

Windows, or:

```bash
ls target
```

Linux/macOS.

---

### Q1.3 Verify generated artifact

Look inside:

```text
target/
```

You should see something like:

```text
project-name-1.0-SNAPSHOT.war
```

or:

```text
project-name-1.0-SNAPSHOT.jar
```

The exact name comes from:

```text
<artifactId>-<version>.<packaging>
```

unless `<finalName>` is explicitly configured.

---

### Q1.4 Force Maven to ignore an unwanted transitive dependency version

Use `<exclusions>`:

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>library-a</artifactId>
    <version>1.0</version>

    <exclusions>
        <exclusion>
            <groupId>org.example</groupId>
            <artifactId>unwanted-library</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

Then explicitly add the version you want as a direct dependency.

---

### Q1.5 Dependency is not recognized by compiler

Check whether Maven downloaded it:

```bash
dir %USERPROFILE%\.m2\repository
```

or Linux/macOS:

```bash
ls ~/.m2/repository
```

Then:

```bash
mvn dependency:tree
```

If the dependency is missing, verify `groupId`, `artifactId`, and `version` in `pom.xml`, then run:

```bash
mvn dependency:resolve
mvn clean compile
```

---

### Q1.6 Convert WAR → standalone JAR

Change:

```xml
<packaging>war</packaging>
```

to:

```xml
<packaging>jar</packaging>
```

Remove WAR/Tomcat-specific configuration if no longer needed.

For an executable JAR, the application must have a `main()` method. A simple Maven JAR manifest configuration is:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.4.2</version>
    <configuration>
        <archive>
            <manifest>
                <mainClass>com.example.Main</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>
```

Replace `com.example.Main` with the actual main class.

Then:

```bash
mvn clean package
java -jar target/<your-jar>.jar
```

If the application requires external dependencies, use a suitable fat-JAR approach such as `maven-shade-plugin` instead of assuming a plain JAR is enough.

---

### Q1.7 Build Java project and explain `target/`

```bash
mvn clean install
```

Typical contents:

```text
target/
├── classes/              # compiled main classes
├── test-classes/         # compiled test classes
├── surefire-reports/     # test reports
├── generated-sources/
└── project-version.jar/war
```

Exact contents depend on the project.

---

### Q1.8 Maven web project → WAR + structure

In `pom.xml`:

```xml
<packaging>war</packaging>
```

Typical structure:

```text
project/
├── pom.xml
└── src/
    ├── main/
    │   ├── java/
    │   ├── resources/
    │   └── webapp/
    │       ├── WEB-INF/
    │       │   └── web.xml
    │       └── index.jsp
    └── test/
        └── java/
```

Build:

```bash
mvn clean package
```

WAR appears in:

```text
target/
```

Deploy the WAR to Tomcat's `webapps/` directory.

---

### Q1.9 Maven web project vs traditional WAR execution

For a normal WAR:

```text
Maven → WAR → external Tomcat → browser
```

A standalone Java application is:

```text
Maven → executable JAR → java -jar
```

A standalone JAR normally needs an embedded server if it is a web application. Simply changing `war` to `jar` does **not magically make Tomcat disappear**.

---

### Q1.10 Production profile + skip tests

Example:

```xml
<profiles>
    <profile>
        <id>prod</id>
        <properties>
            <db.url>...</db.url>
        </properties>
    </profile>
</profiles>
```

Run:

```bash
mvn clean package -Pprod -DskipTests
```

---

### Q1.11 Full dependency hierarchy

```bash
mvn dependency:tree
```

---

### Q1.12 `compile` vs `package`

Correct idea:

```text
compile  → .class files
package  → JAR/WAR
```

So:

```bash
mvn compile
mvn package
```

---

### Q1.13 Delete old build output

```bash
mvn clean
```

Fresh build:

```bash
mvn clean package
```

---

# Part II – Git/GitHub

### Q2.1 Initialize repository and add files

```bash
git init
git add .
git commit -m "Initial commit"
```

---

### Q2.2 Configure Git globally and push to GitHub

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

git remote -v
git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```

If `origin` already exists, do not add it again.

---

### Q2.3 Stash work → main → fix → return → restore

```bash
git stash
git switch main
# fix bug
git add .
git commit -m "Fix critical bug"
git switch <feature-branch>
git stash pop
```

---

### Q2.4 Merge conflict workflow

```bash
git merge feature-branch
git status
```

Git tells you the conflicting files.

Open them and remove:

```text
<<<<<<< HEAD
your version
=======
their version
>>>>>>> feature-branch
```

Keep the correct code.

Then:

```bash
git add <resolved-file>
git commit
```

If Git asks you to continue a merge, follow its message.

---

### Q2.5 Verify remote and rename `origin`

```bash
git remote -v
git remote rename origin metro-origin
git remote -v
```

---

### Q2.6 Create `feature/fare-calculator` from `main`

```bash
git switch -c feature/fare-calculator main
```

---

### Q2.7 Same lines changed in `TicketController.java`

This is a **merge conflict**.

```bash
git merge feature/qr-scanner
git status
```

Open `TicketController.java`, manually choose/combine the correct code, then:

```bash
git add TicketController.java
git commit
```

---

### Q2.8 Safely undo a bad pushed commit

Use:

```bash
git revert <bad-commit-id>
git push origin main
```

`revert` creates a new commit and preserves history.

---

### Q2.9 Find who changed a particular line in `FareMatrix.json`

```bash
git blame FareMatrix.json
```

For deeper history:

```bash
git log -p -- FareMatrix.json
```

---

### Q2.10 Push modified `BookingRegister.jsp`

```bash
git status
git add BookingRegister.jsp
git commit -m "Update booking register"
git push origin <branch-name>
```

For first push:

```bash
git push -u origin <branch-name>
```

---

### Q2.11 Undo wrong `register.jsp` commit cleanly

If already committed:

```bash
git revert <commit-id>
git push
```

Do **not** use reset/rebase on a shared remote branch unless you have explicitly been told to rewrite history.

---

### Q2.12 Unstage `db_passwords.env` but keep file

```bash
git restore --staged db_passwords.env
```

Older equivalent:

```bash
git reset HEAD db_passwords.env
```

---

### Q2.13 Who last modified `login.jsp`?

```bash
git log -1 -- login.jsp
```

For line-by-line ownership:

```bash
git blame login.jsp
```

---

### Q2.14 Full details of last commit

```bash
git show HEAD
```

---

# Part III – Docker

### Q3.1 Dockerfile for WAR + Tomcat

```dockerfile
FROM tomcat:9-jdk17

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

Build first:

```bash
mvn clean package
```

Then:

```bash
docker build -t metro-app .
```

---

### Q3.2 PostgreSQL container `metro-db`

```bash
docker run -d --name metro-db -p 5432:5432 postgres
```

In a real lab, add the required database environment variables if the question/repo requires them.

---

### Q3.3 Host port 80 → container port 8082

```bash
docker run -d --name metro-app -p 80:8082 <image>
```

Remember:

```text
-p HOST_PORT:CONTAINER_PORT
```

---

### Q3.4 View real-time logs

```bash
docker logs -f metro-applogs
```

If `metro-applogs` is the actual **container name**.

---

### Q3.5 Update container with newly built WAR

Usually:

```bash
mvn clean package
docker build -t metro-app .
docker stop metro-app-container
docker rm metro-app-container
docker run -d --name metro-app-container -p 8080:8080 metro-app
```

A running container does not automatically receive a newly built image.

---

### Q3.6 Enter running container

```bash
docker exec -it <container-name> sh
```

If Bash exists:

```bash
docker exec -it <container-name> bash
```

---

### Q3.7 Clean unused Docker resources

The paper's wording says "all unused images, stopped containers, and build cache layers":

```bash
docker system prune -a
```

This is destructive for unused resources. Read the confirmation prompt.

---

### Q3.8 Run container in background

```bash
docker run -d --name metro-app <image>
```

`-d` = detached/background mode.

---

### Q3.9 Force stop + remove in one line

```bash
docker rm -f <container-name>
```

---

# 2. PAPER / SET 2 – CAR BOOKING SYSTEM

**Source file:** `Set-2 (2).docx`  
**Repository:** `https://github.com/anujyog1/carrepo.git`

## Part I – Maven

### Clone/build

```bash
git clone https://github.com/anujyog1/carrepo.git
cd carrepo
mvn clean package
dir target
```

### Patch file

Apply:

```bash
git apply bugfix.patch
```

Check:

```bash
git diff
```

Then build:

```bash
mvn clean package
```

If the patch is a Git-format patch containing commits:

```bash
git am < bugfix.patch
```

### Change Maven output directory

In `pom.xml`:

```xml
<build>
    <directory>${project.basedir}/build_output</directory>
</build>
```

Then:

```bash
mvn clean package
```

### Maven dependency conflicts

Maven normally uses **nearest definition** in the dependency tree. If two dependencies introduce different versions, inspect:

```bash
mvn dependency:tree
```

Force a desired version by declaring that dependency directly in your POM, or exclude the unwanted transitive dependency.

### Build WAR + deploy to Tomcat

```bash
mvn clean package
```

WAR:

```text
target/<artifactId>-<version>.war
```

Copy it to Tomcat:

```text
TOMCAT_HOME/webapps/
```

Then start Tomcat and open:

```text
http://localhost:8080/<war-context>
```

### Executable JAR

Use `maven-jar-plugin` for the main class manifest:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.4.2</version>
    <configuration>
        <archive>
            <manifest>
                <mainClass>com.example.Main</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>
```

Then:

```bash
mvn clean package
java -jar target/<jar-file>.jar
```

### Skip test execution completely

The paper explicitly asks for complete skipping:

```bash
mvn package -Dmaven.test.skip=true
```

`-DskipTests` skips **execution** but still compiles tests. `-Dmaven.test.skip=true` skips test compilation and execution.

### Dependency tree

```bash
mvn dependency:tree
```

### Define Java 17 once

In `<properties>`:

```xml
<properties>
    <maven.compiler.release>17</maven.compiler.release>
</properties>
```

or:

```xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
</properties>
```

Prefer `release` when supported by your Maven Compiler Plugin.

### Servlet API scope

```xml
<scope>provided</scope>
```

Meaning: needed to compile, but Tomcat supplies it at runtime and it should not be packaged into the WAR.

### Maven local repository

Default:

```text
Windows: C:\Users\<username>\.m2\repository
Linux/macOS: ~/.m2/repository
```

If a downloaded artifact is corrupted, delete the relevant artifact directory and rebuild. To clear the entire local cache:

```bash
rmdir /s /q "%USERPROFILE%\.m2\repository"
```

Linux/macOS:

```bash
rm -rf ~/.m2/repository
```

Then Maven downloads dependencies again.

---

## Part II – Git

### Initialize + first commit

```bash
git init
git add .
git commit -m "Initial commit"
```

### Global configuration + GitHub push

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```

### `feature/engine-update` tracking a remote branch

Create/switch:

```bash
git switch -c feature/engine-update
```

Push and establish upstream:

```bash
git push -u origin feature/engine-update
```

After this, the local branch tracks the remote branch.

### Stash incomplete `CarController.java`

```bash
git stash push -m "unfinished CarController work"
git switch main
# fix hotfix
git add .
git commit -m "Hotfix"
git switch feature/engine-update
git stash pop
```

### Forgotten file + fix previous commit message without second commit

```bash
git add forgotten-file
git commit --amend --no-edit
```

If changing the message too:

```bash
git commit --amend -m "Corrected commit message"
```

### Move uncommitted changes to `feature-login`

If you are on the wrong branch:

```bash
git stash
git switch feature-login
git stash pop
```

### Resolve `login.jsp` merge conflict

```bash
git merge feature-user
git status
```

Edit `login.jsp`, remove conflict markers, keep correct code:

```bash
git add login.jsp
git commit
```

### Discard changes to `app.js`

```bash
git restore app.js
```

### Unstage `secret.env`

```bash
git restore --staged secret.env
```

### See exact lines changed before staging

```bash
git diff
```

For staged changes:

```bash
git diff --cached
```

### Check current branch and switch to main

```bash
git branch --show-current
git switch main
```

### Last 4 commits compactly

```bash
git log --oneline -4
```

### Get remote updates, apply changes, push

```bash
git fetch origin
git switch main
git pull --ff-only origin main

# make your changes
git add .
git commit -m "Update application"
git push origin main
```

If working on a feature branch, push that branch instead.

### Delete merged bugfix branch

```bash
git branch -d bugfix
```

Force delete:

```bash
git branch -D bugfix
```

---

## Part III – Docker

### WAR on Tomcat Dockerfile

```dockerfile
FROM tomcat:9-jdk17

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

### Build/run

```bash
mvn clean package
docker build -t carrepo .
docker run -d --name carrepo-container -p 8080:8080 carrepo
```

### Logs + shell

```bash
docker logs <container>
docker exec -it <container> sh
```

### Cleanup

```bash
docker system prune
```

Safety-checked: Docker asks for confirmation.

### Redis

Create/start:

```bash
docker run -d --name my-redis redis
```

Open Redis CLI:

```bash
docker exec -it my-redis redis-cli
```

Exit:

```text
exit
```

### Check running containers

```bash
docker ps
```

### Host 8080 → container 5000

```bash
docker run -d --name car_app -p 8080:5000 car_app
```

### Tag an existing image

```bash
docker tag car_app <dockerhub-username>/car_app:v1
```

### Enter container shell

```bash
docker exec -it car_app sh
```

### Limit RAM

Example 512 MB:

```bash
docker run -d --memory=512m --name car_app car_app
```

---

# 3. PAPER / SET 3 – ONLINE BOUTIQUE STORE (OBS)

**Source file:** `Set-4 (2).docx`  
**Repository:** `https://github.com/haleema91/Internal-1-OBS.git`

The paper is labelled **SET-III**.

## Part I – Maven

### 1. Clone

```bash
git clone https://github.com/haleema91/Internal-1-OBS.git
cd Internal-1-OBS
```

### 2. Find POM errors

The exact broken lines are not printed in the paper. Do:

```bash
mvn validate
```

Read the **first Maven model/POM error**, then inspect `pom.xml`.

Check especially:

- malformed XML
- missing `groupId`, `artifactId`, or `version`
- invalid dependency placement
- invalid packaging
- plugin typos
- Java source/target version
- incorrect repository coordinates

Then:

```bash
mvn help:effective-pom
```

### 3. Build and run

Build:

```bash
mvn clean package
```

Run depends on whether it is JAR or web app.

For executable JAR:

```bash
java -jar target/<jar>.jar
```

### 4. WAR → standalone JAR

```xml
<packaging>jar</packaging>
```

Add an executable JAR configuration with the correct main class, then:

```bash
mvn clean package
java -jar target/<jar>.jar
```

If it is a web application, use an embedded web server rather than assuming a plain JAR can serve HTTP.

### 5. MySQL dependency

Use MySQL Connector/J:

```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>YOUR_REQUIRED_VERSION</version>
</dependency>
```

Download/resolve:

```bash
mvn dependency:resolve
```

or simply:

```bash
mvn clean compile
```

The paper does not specify the required Connector/J version, so use the version required by your lab POM/instructor.

### 6. Java compilation error: Source option 5

The compiler is using an old source/target level.

Configure Maven Compiler Plugin:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.13.0</version>
    <configuration>
        <release>17</release>
    </configuration>
</plugin>
```

Or use the appropriate Java version required by the lab.

### 7. Dependency cannot resolve

Check:

```xml
<groupId>...</groupId>
<artifactId>...</artifactId>
<version>...</version>
```

Commands:

```bash
mvn dependency:tree
mvn dependency:resolve
mvn help:effective-pom
mvn -X clean compile
```

### 8. `1.0-SNAPSHOT` → `1.0`

Change:

```xml
<version>1.0-SNAPSHOT</version>
```

to:

```xml
<version>1.0</version>
```

`SNAPSHOT` = development version that may change.

`1.0` = release version intended to be stable/immutable.

### 9. Dependency tree

```bash
mvn dependency:tree
```

### 10. Push project to GitHub

```bash
git init
git add .
git commit -m "Initial OBS project"
git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```

---

## Part II – Git

### 1. Check remote

```bash
git remote -v
```

### 2. Create `product-search`

```bash
git switch -c product-search
```

### 3. Show changes in `Product.java` and `Order.java`

```bash
git diff -- Product.java Order.java
```

### 4. Restore `Customer.java`

```bash
git restore Customer.java
```

This permanently discards its uncommitted changes.

### 5. Fetch without modifying current branch

```bash
git fetch origin
```

Difference:

```text
git fetch = download remote updates, don't merge them
git pull  = fetch + integrate into current branch
```

### 6. Update clean local `main`

```bash
git switch main
git pull origin main
```

### 7. Rebase feature branch onto latest main

```bash
git switch product-search
git fetch origin
git rebase origin/main
```

If conflict:

```bash
# fix file
git add <file>
git rebase --continue
```

Abort:

```bash
git rebase --abort
```

### 8. Merge product-search into main

```bash
git switch main
git pull origin main
git merge product-search
git push origin main
```

### 9. SSH authentication

Generate key:

```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

Start agent/add key as appropriate for your OS.

Display public key:

```bash
type %USERPROFILE%\.ssh\id_ed25519.pub
```

Linux/macOS:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy it to:

**GitHub → Settings → SSH and GPG keys → New SSH key**

Test:

```bash
ssh -T git@github.com
```

Change remote to SSH if necessary:

```bash
git remote set-url origin git@github.com:<username>/<repo>.git
```

### 10. Fork workflow

```text
Original GitHub repository
        ↓
      Fork
        ↓
Your GitHub repository
        ↓
Clone
        ↓
Create feature branch
        ↓
Commit + push
        ↓
Pull Request to original repository
```

Commands:

```bash
git clone <YOUR_FORK_URL>
git switch -c product-search
git add .
git commit -m "Add product search"
git push -u origin product-search
```

Then create a Pull Request from your fork to the original repository.

---

## Part III – Docker

### Dockerfile for standalone OBS JAR

```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/online-boutique-store.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Important:** The exact JAR filename must match the actual file in `target/`.

Build:

```bash
mvn clean package
docker build -t OBS .
```

Run:

```bash
docker run -d --name obs-container -p 8080:8080 OBS
```

Verify:

```bash
docker ps
docker logs obs-container
```

### Enter running container

```bash
docker exec -it obs-container sh
```

Then:

```bash
ls
```

### Replace old container with new image

```bash
mvn clean package
docker build -t OBS .
docker stop obs-container
docker rm obs-container
docker run -d --name obs-container -p 8080:8080 OBS
```

### Nginx on port 8081

```bash
docker pull nginx
docker run -d --name nginx-container -p 8081:80 nginx
```

### Check what is using port 8081

Docker:

```bash
docker ps
```

Look at the `PORTS` column.

More specifically:

```bash
docker ps --filter "publish=8081"
```

On Windows host process inspection:

```bash
netstat -ano | findstr :8081
```

---

# 4. PAPER / SET 4 – ONLINE VEHICLE RENTAL (OVR)

**Source file:** `Set-5 (1).docx`  
**Repository:** `https://github.com/haleema91/Internal-1-OVR.git`

## Part I – Maven

### 1. Clone

```bash
git clone https://github.com/haleema91/Internal-1-OVR.git
cd Internal-1-OVR
```

### 2. Identify POM errors

The exact errors are not supplied in the paper.

Run:

```bash
mvn validate
```

Then inspect `pom.xml`.

For dependency issues:

```bash
mvn dependency:tree
mvn dependency:resolve
```

For maximum diagnostic output:

```bash
mvn -X validate
```

### 3. Build/run

```bash
mvn clean package
```

If executable JAR:

```bash
java -jar target/<jar>.jar
```

### 4. WAR → JAR

```xml
<packaging>jar</packaging>
```

Remove WAR-specific setup and configure the main class if an executable JAR is required.

### 5. PostgreSQL JDBC dependency

```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>YOUR_REQUIRED_VERSION</version>
</dependency>
```

Resolve:

```bash
mvn dependency:resolve
```

### 6. JUnit dependency needs a version

Example JUnit 4:

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>
```

If the project's tests use JUnit 5, use the JUnit 5 dependency required by the project instead.

### 7. Skip tests

```bash
mvn clean package -DskipTests
```

For complete test compilation + execution skip:

```bash
mvn clean package -Dmaven.test.skip=true
```

### 8. Build + `target/`

```bash
mvn clean install
```

Typical:

```text
target/classes
target/test-classes
target/surefire-reports
target/<artifact>.jar or .war
```

### 9. Unsupported class version

Review:

```text
maven-compiler-plugin
```

Example:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.13.0</version>
    <configuration>
        <release>17</release>
    </configuration>
</plugin>
```

Use the Java release actually required by the project.

### 10. Push to GitHub

```bash
git init
git add .
git commit -m "Initial OVR project"
git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```

---

## Part II – Git

### 1. Initialize

```bash
git init
```

### 2. Configure requested identity

```bash
git config --global user.name "rentaldev"
git config --global user.email "dev@rental.com"
```

### 3. Stage `VehicleService.java`

```bash
git add VehicleService.java
```

### 4. Commit exact message

```bash
git commit -m "Added Vehicle Management Module"
```

### 5. Diff `VehicleController.java`

```bash
git diff -- VehicleController.java
```

### 6. Complete commit history

```bash
git log
```

### 7. Unstage `application.properties`

```bash
git restore --staged application.properties
```

### 8. Discard uncommitted `RentalService.java`

```bash
git restore RentalService.java
```

### 9. Create `vehicle-booking`

```bash
git switch -c vehicle-booking
```

### 10. Rebase feature commits on latest main

```bash
git fetch origin
git switch vehicle-booking
git rebase origin/main
```

### 11. `payment` branch behind main

A safe sequence:

```bash
git fetch origin
git switch payment
git rebase origin/main
```

If you do not want to rewrite your feature branch history, merge instead:

```bash
git merge origin/main
```

### 12. Switch to main

```bash
git switch main
```

---

## Part III – Docker

### Dockerfile

For a WAR deployed to Tomcat:

```dockerfile
FROM tomcat:9-jdk17

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

Build/run:

```bash
mvn clean package
docker build -t OVR .
docker run -d --name OVR-container -p 8080:8080 OVR
```

### Running containers

```bash
docker ps
```

### Stop OVR

```bash
docker stop OVR-container
```

### Logs

```bash
docker logs OVR-container
```

### List images

```bash
docker images
```

### Push OVR to Docker Hub

```bash
docker login
docker tag OVR <dockerhub-username>/ovr:v1
docker push <dockerhub-username>/ovr:v1
```

---

# 5. PAPER / SET 5 – ONLINE EVENT MANAGEMENT SYSTEM (OEMS)

**Source file:** `Set-6 (1).docx`  
**Repository:** `https://github.com/haleema91/Internal-1-OEMS.git`

## Part I – Maven Web Application

### 1. Clone

```bash
git clone https://github.com/haleema91/Internal-1-OEMS.git
cd Internal-1-OEMS
```

### 2. Identify POM errors

Not enough information is printed in the paper to name the exact broken lines.

Run:

```bash
mvn validate
```

Then inspect `pom.xml`.

### 3. Build WAR

```bash
mvn clean package
```

Verify:

```bash
dir target
```

Look for:

```text
*.war
```

### 4. Correct packaging for Tomcat

```xml
<packaging>war</packaging>
```

### 5. Servlet API + JSTL

For the older `javax.servlet` stack, a typical setup is:

```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>YOUR_REQUIRED_VERSION</version>
    <scope>provided</scope>
</dependency>
```

JSTL:

```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jstl</artifactId>
    <version>YOUR_REQUIRED_VERSION</version>
</dependency>
```

Use the exact versions compatible with the project's Servlet/Tomcat version.

### 6. Older Java + newer JDK

Use Maven Compiler Plugin:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.13.0</version>
    <configuration>
        <release>17</release>
    </configuration>
</plugin>
```

### 7. Port 8080 already in use

Windows:

```bash
netstat -ano | findstr :8080
```

Then:

```bash
tasklist | findstr <PID>
```

Terminate the process if appropriate:

```bash
taskkill /PID <PID> /F
```

Or change Tomcat's port if you do not want to stop the existing service.

Linux/macOS:

```bash
lsof -i :8080
```

### 8. Clean old build output

```bash
mvn clean package
```

### 9. Java 17 project but Java 21 installed

Configure:

```xml
<configuration>
    <release>17</release>
</configuration>
```

But this only works if a Java 17 JDK is actually available where Maven can use it. Check:

```bash
mvn -version
```

If Maven itself is running on Java 21, installing/configuring JDK 17 may be necessary depending on the project/toolchain.

### 10. Push to GitHub

```bash
git init
git add .
git commit -m "Initial OEMS project"
git branch -M main
git remote add origin <YOUR_GITHUB_REPO_URL>
git push -u origin main
```

---

## Part II – Git

### 1. Existing project → Git

```bash
git init
git add .
git commit -m "Initial commit"
```

### 2. Check Event.java + Registration.java changes

```bash
git status
git diff
```

### 3. Create registration branch

```bash
git switch -c registration
```

### 4. Merge registration into main

```bash
git switch main
git pull origin main
git merge registration
git push origin main
```

### 5. Resolve `Registration.java` conflict

```bash
git status
```

Edit the conflicting file and remove:

```text
<<<<<<<
=======
>>>>>>>
```

Then:

```bash
git add Registration.java
git commit
```

### 6. Create patch from uncommitted `Event.java`

```bash
git diff -- Event.java > event-availability.patch
```

Share `event-availability.patch`.

### 7. Apply teammate's patch

```bash
git apply booking.patch
```

Then inspect:

```bash
git diff
```

### 8. Undo pushed bad commit safely

```bash
git revert <bad-commit-id>
git push origin registration
```

### 9. Discard uncommitted `EventServlet.java`

```bash
git restore EventServlet.java
```

### 10. Unstage `Registration.java`

```bash
git restore --staged Registration.java
```

### 11. Registration branch behind main

```bash
git fetch origin
git switch registration
git rebase origin/main
```

Or merge:

```bash
git merge origin/main
```

### 12. Switch back to main

```bash
git switch main
```

---

## Part III – Docker

### Dockerfile for OEMS WAR

```dockerfile
FROM tomcat:9-jdk17

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

### Build/run on host port 7070

```bash
mvn clean package
docker build -t oems-web .
docker run -d --name oems-container -p 7070:8080 oems-web
```

Open:

```text
http://localhost:7070/
```

The actual context path depends on the WAR filename.

### Enter container

```bash
docker exec -it oems-container sh
```

Check:

```bash
ls /usr/local/tomcat/webapps
```

### Logs

```bash
docker logs oems-container
```

### Background mode

```bash
docker run -d --name oems-container -p 7070:8080 oems-web
```

### Ubuntu + Git

```bash
docker pull ubuntu
docker run -dit --name ubuntu-git ubuntu
docker exec -it ubuntu-git bash
```

Inside:

```bash
apt update
apt install git -y
git --version
git init
git status
```

Exit:

```bash
exit
```

### Docker Hub

```bash
docker login
docker tag oems-web <dockerhub-username>/oems-web:v1
docker push <dockerhub-username>/oems-web:v1
```

---

# 6. PAPER / SET 6 – SPORTS MANAGEMENT SYSTEM

**Source file:** `SET-7 (1).doc`  
**Repository:** `https://github.com/sarasrija/SportManagementSystem.git`

The paper itself is labelled **Lab Internal I SET-1** and is for the Sports Management System.

## Part I – Git

### 1. Clone

```bash
git clone https://github.com/sarasrija/SportManagementSystem.git
cd SportManagementSystem
```

### 2. Verify remote

```bash
git remote -v
```

### 3. Status

```bash
git status
```

### 4. Create + switch in one operation

```bash
git switch -c feature/player-registration
```

### 5. All branches + current branch

```bash
git branch -a
git branch --show-current
```

### 6. Commit exact file

```bash
git add src/main/java/com/sports/servlet/RegistrationServlet.java
git commit -m "Add player registration servlet"
```

### 7. Add forgotten `web.xml` to last commit without changing message

```bash
git add src/main/webapp/WEB-INF/web.xml
git commit --amend --no-edit
```

### 8. Download remote updates without changing working files

```bash
git fetch origin
```

### 9. Incorporate latest remote main into current branch

```bash
git fetch origin
git merge origin/main
```

### 10. Rebase feature branch onto updated main

```bash
git fetch origin
git rebase origin/main
```

### 11. Abort failed rebase

```bash
git rebase --abort
```

### 12. Undo faulty test commit, preserve history

```bash
git revert <commit-id>
```

### 13. Undo last commit, keep changes staged

```bash
git reset --soft HEAD~1
```

### 14. Remove `db-config.env` from version control, keep local file

```bash
git rm --cached src/main/resources/db-config.env
git commit -m "Stop tracking db config"
```

Also add it to `.gitignore` so it is not accidentally committed again:

```text
db-config.env
```

### 15. Stash unfinished `schedule.jsp`

```bash
git stash push -m "unfinished schedule.jsp"
```

### 16. List and restore stash

```bash
git stash list
git stash pop
```

### 17. Compare `index.jsp` between feature and main

```bash
git diff main...feature/player-registration -- src/main/webapp/index.jsp
```

### 18. Compact visual history

```bash
git log --oneline --graph --decorate --all
```

### 19. Merge feature into main

```bash
git switch main
git merge feature/player-registration
```

### 20. Push and verify same commit point

```bash
git push origin main
git fetch origin
git rev-parse main
git rev-parse origin/main
```

If both hashes are identical, they point to the same commit.

---

## Part II – Maven

This paper repeats the same Maven debugging concepts as the other DevOps papers.

### Q1. Exact POM schema violation

**Missing context:** the actual broken `pom.xml` is not included in the question paper.

Do:

```bash
mvn validate
```

The first parsing/model error identifies the invalid XML/POM structure.

A dependency should generally look like:

```xml
<dependency>
    <groupId>...</groupId>
    <artifactId>...</artifactId>
    <version>...</version>
</dependency>
```

Do not invent the actual coordinates until you inspect the POM.

### Q1.2 `tomcat7:run` plugin

Again, the exact broken plugin configuration is not printed.

Inspect:

```xml
<build>
    <plugins>
        ...
    </plugins>
</build>
```

A typical Tomcat 7 plugin block is:

```xml
<plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
    <configuration>
        <url>http://localhost:8080/manager/text</url>
        <path>/your-app</path>
    </configuration>
</plugin>
```

The exact correction depends on what is wrong in the provided POM.

### Q2.1 MySQL dependency

Typical:

```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>YOUR_REQUIRED_VERSION</version>
</dependency>
```

### Q2.2 Incomplete test dependency

The missing element is usually `<version>` if the question says the dependency declaration is incomplete.

Example:

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>
```

If the actual POM shows a different missing element, follow Maven's error.

### Q3. Exact WAR filename

Cannot be determined from the paper alone.

Look at:

```xml
<artifactId>...</artifactId>
<version>...</version>
<packaging>war</packaging>
```

If no `<finalName>` exists:

```text
target/<artifactId>-<version>.war
```

If:

```xml
<finalName>something</finalName>
```

then:

```text
target/something.war
```

### Q3.2 Context path

Cannot be determined without the actual plugin configuration.

Look for:

```xml
<path>/something</path>
```

Then normally:

```text
http://localhost:8080/something
```

### Q4. `pluginManagement` vs `plugins`

`pluginManagement`:

- defines/configures plugin defaults
- does **not** activate the plugin by itself

`plugins`:

- actually declares the plugin for the project build
- its goals/configuration can participate in the lifecycle

### Q4.2 SNAPSHOT

`0.0.1-SNAPSHOT` means development version.

Snapshot artifacts can change between builds; Maven may check remote repositories for newer snapshot metadata/artifacts.

Release versions such as `0.0.1` are intended to be stable and not replaced.

### Q5. Maven's JDK version

```bash
mvn -version
```

### Q5.2 Clean + package + full debug

```bash
mvn clean package -X
```

### Q6. Install local `sports-analytics.jar`

The question says "using the coordinates specified in the POM" but does not print those coordinates.

Template:

```bash
mvn install:install-file ^
  -Dfile=sports-analytics.jar ^
  -DgroupId=<GROUP_ID_FROM_POM> ^
  -DartifactId=<ARTIFACT_ID_FROM_POM> ^
  -Dversion=<VERSION_FROM_POM> ^
  -Dpackaging=jar
```

Linux/macOS:

```bash
mvn install:install-file \
  -Dfile=sports-analytics.jar \
  -DgroupId=<GROUP_ID_FROM_POM> \
  -DartifactId=<ARTIFACT_ID_FROM_POM> \
  -Dversion=<VERSION_FROM_POM> \
  -Dpackaging=jar
```

### Q6.2 Dependency tree

```bash
mvn dependency:tree
```

### Q7. Maven test paths

Compiled test classes:

```text
target/test-classes/
```

JUnit/Surefire reports:

```text
target/surefire-reports/
```

### Q7.2 Single `Tournament BracketTest`

Because the paper writes the class name with a space, the likely intended Java class is probably something such as `TournamentBracketTest`. Maven command:

```bash
mvn -Dtest=TournamentBracketTest test
```

If the actual class name really contains a space, Java class naming rules mean that is not a valid ordinary class name.

### Q7.3 Continue packaging despite test failures

```bash
mvn package -Dmaven.test.failure.ignore=true
```

### Q8. Dependency usage analysis

```bash
mvn dependency:analyze
```

### Q8.2 `provided` Servlet API

Use:

```xml
<scope>provided</scope>
```

because Tomcat supplies the Servlet API at runtime.

If packaged unnecessarily, you can get duplicate/incompatible Servlet classes and class-loading/runtime problems.

---

## Part III – Docker

### 1. Clone/check project

```bash
git clone https://github.com/sarasrija/SportManagementSystem.git
cd SportManagementSystem
dir
```

Look for `pom.xml`, `src/`, and `target/`.

### 2. Required Dockerfile

```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/sports-management.jar sports-management.jar

EXPOSE 8080

CMD ["java", "-jar", "sports-management.jar"]
```

If the actual JAR filename differs, use the actual file.

### 3. Build image

```bash
docker build -t sportsapp-image .
```

### 4. Run in background with port mapping

```bash
docker run -d --name sports-app-container -p 8080:8080 sportsapp-image
```

### 5. Running containers

```bash
docker ps
```

### 6. All containers

```bash
docker ps -a
```

### 7. Enter container

```bash
docker exec -it sports-app-container sh
```

### 8. Stop then restart

```bash
docker stop sports-app-container
docker start sports-app-container
```

### 9. Save container as image

```bash
docker commit 0e993d2009a1 <your_dockerhub_username>/sportsapp:v1
```

### 10. Login

```bash
docker login
```

### 11. Push

```bash
docker push <your_dockerhub_username>/sportsapp:v1
```

### 12. Logout

```bash
docker logout
```

---

# 7. PAPER / SET 7 – BLOOD BANK MANAGEMENT SYSTEM

**Source file:** `SET-8.doc`  
**Repository:** `https://github.com/sarasrija/Blood-Bank-Management-system.git`

The paper is labelled **SET-3**.

## Part I – Git

The Git questions are structurally the same as Sports, with different names.

### 1. Clone

```bash
git clone https://github.com/sarasrija/Blood-Bank-Management-system.git
cd Blood-Bank-Management-system
```

### 2. Remote URL

```bash
git remote -v
```

### 3. Status

```bash
git status
```

### 4. Create/switch branch

```bash
git switch -c feature/donor-registration
```

### 5. Local + remote branches/current branch

```bash
git branch -a
git branch --show-current
```

### 6. Commit `DonorServlet.java`

```bash
git add src/main/java/com/bloodbank/servlet/DonorServlet.java
git commit -m "Add donor registration servlet"
```

### 7. Add forgotten `web.xml` to previous commit

```bash
git add src/main/webapp/WEB-INF/web.xml
git commit --amend --no-edit
```

### 8. Fetch only

```bash
git fetch origin
```

### 9. Incorporate remote main

```bash
git fetch origin
git merge origin/main
```

### 10. Rebase feature on main

```bash
git fetch origin
git rebase origin/main
```

### 11. Abort rebase

```bash
git rebase --abort
```

### 12. Revert faulty `DonorTest.java` commit

```bash
git revert <commit-id>
```

### 13. Undo last commit, keep changes staged

```bash
git reset --soft HEAD~1
```

### 14. Remove `db-config.env` from tracking but keep it

```bash
git rm --cached src/main/resources/db-config.env
git commit -m "Stop tracking database config"
```

Add to `.gitignore`.

### 15. Stash inventory work

```bash
git stash push -m "unfinished inventory.jsp"
```

### 16. List + restore

```bash
git stash list
git stash pop
```

### 17. Compare feature vs main for `index.jsp`

```bash
git diff main...feature/donor-registration -- src/main/webapp/index.jsp
```

### 18. Compact visual history

```bash
git log --oneline --graph --decorate --all
```

### 19. Merge into main

```bash
git switch main
git merge feature/donor-registration
```

### 20. Push + verify same commit

```bash
git push origin main
git fetch origin
git rev-parse main
git rev-parse origin/main
```

The hashes should match.

---

## Part II – Maven

The paper uses the same POM-debugging questions as Sports. Use the same methods:

```bash
mvn validate
mvn dependency:tree
mvn dependency:resolve
mvn -X clean package
mvn -version
mvn dependency:analyze
```

For the exact POM schema violation, exact WAR name, exact context path, and exact vendor-library coordinates, inspect the provided repository's `pom.xml`; those details are not printed in the paper.

For the `blood-analytics.jar` local installation:

```bash
mvn install:install-file \
  -Dfile=blood-analytics.jar \
  -DgroupId=<GROUP_ID_FROM_POM> \
  -DartifactId=<ARTIFACT_ID_FROM_POM> \
  -Dversion=<VERSION_FROM_POM> \
  -Dpackaging=jar
```

For the requested test:

```bash
mvn -Dtest=DonorTest test
```

For ignoring test failures during packaging:

```bash
mvn package -Dmaven.test.failure.ignore=true
```

---

## Part III – Docker

### Dockerfile

```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/Blood-managent.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
```

The paper spells the JAR as `Blood-managent.jar`; use the actual generated filename if it differs.

### Build/run

```bash
docker build -t Bloodbankapp-image .
docker run -d --name Bloodbank-app-container -p 8080:8080 Bloodbankapp-image
```

### Running/all containers

```bash
docker ps
docker ps -a
```

### Enter shell

```bash
docker exec -it Bloodbank-app-container sh
```

### Stop/restart

```bash
docker stop Bloodbank-app-container
docker start Bloodbank-app-container
```

### Commit running container to image

```bash
docker commit 0e993d2009a1 <your_dockerhub_username>/Bloodbankapp:v1
```

### Login/push/logout

```bash
docker login
docker push <your_dockerhub_username>/Bloodbankapp:v1
docker logout
```

---

# 8. PAPER / SET 8 – APARTMENT MANAGEMENT SYSTEM

**Source file:** `SET-9.doc`  
**Repository:** `https://github.com/sarasrija/ApartmentManagementSystem.git`

The paper is labelled **SET-2**.

## Part I – Git

### 1. Clone

```bash
git clone https://github.com/sarasrija/ApartmentManagementSystem.git
cd ApartmentManagementSystem
```

### 2. Verify remote

```bash
git remote -v
```

### 3. Status

```bash
git status
```

### 4. Create/switch branch

```bash
git switch -c feature/tenant-registration
```

### 5. All branches + current

```bash
git branch -a
git branch --show-current
```

### 6. Commit `TenantServlet.java`

```bash
git add src/main/java/com/apartment/servlet/TenantServlet.java
git commit -m "Add tenant registration servlet"
```

### 7. Add forgotten `web.xml` to previous commit

```bash
git add src/main/webapp/WEB-INF/web.xml
git commit --amend --no-edit
```

### 8. Fetch only

```bash
git fetch origin
```

### 9. Merge latest main into current branch

```bash
git fetch origin
git merge origin/main
```

### 10. Rebase onto updated main

```bash
git fetch origin
git rebase origin/main
```

### 11. Abort rebase

```bash
git rebase --abort
```

### 12. Revert faulty validation commit

```bash
git revert <commit-id>
```

### 13. Undo last commit, keep staged

```bash
git reset --soft HEAD~1
```

### 14. Stop tracking `db-config.env`, keep local file

```bash
git rm --cached src/main/resources/db-config.env
git commit -m "Stop tracking database config"
```

Add:

```text
db-config.env
```

to `.gitignore`.

### 15. Stash unfinished `complaints.jsp`

```bash
git stash push -m "unfinished complaints.jsp"
```

### 16. Restore stash

```bash
git stash list
git stash pop
```

### 17. Compare `index.jsp`

```bash
git diff main...feature/tenant-registration -- src/main/webapp/index.jsp
```

### 18. Compact graph

```bash
git log --oneline --graph --decorate --all
```

### 19. Merge feature

```bash
git switch main
git merge feature/tenant-registration
```

### 20. Push + compare hashes

```bash
git push origin main
git fetch origin
git rev-parse main
git rev-parse origin/main
```

---

## Part II – Maven

### POM debugging

Exact broken XML/configuration is not printed in the paper.

Use:

```bash
mvn validate
mvn dependency:tree
mvn dependency:resolve
mvn -X clean package
```

### Exact WAR filename

Read:

```xml
<artifactId>...</artifactId>
<version>...</version>
<packaging>war</packaging>
```

Default:

```text
target/<artifactId>-<version>.war
```

If `<finalName>` exists, use that instead.

### Context path

Look in the embedded Tomcat plugin configuration for:

```xml
<path>/...</path>
```

### JDK version

```bash
mvn -version
```

### Clean + package + debug

```bash
mvn clean package -X
```

### Install `apartment-analytics.jar`

Coordinates are not printed in the question. Template:

```bash
mvn install:install-file \
  -Dfile=apartment-analytics.jar \
  -DgroupId=<GROUP_ID_FROM_POM> \
  -DartifactId=<ARTIFACT_ID_FROM_POM> \
  -Dversion=<VERSION_FROM_POM> \
  -Dpackaging=jar
```

### Dependency tree

```bash
mvn dependency:tree
```

### Test paths

```text
target/test-classes/
target/surefire-reports/
```

### Single `MaintenanceBillingTest`

```bash
mvn -Dtest=MaintenanceBillingTest test
```

### Package even if tests fail

```bash
mvn package -Dmaven.test.failure.ignore=true
```

### Dependency analysis

```bash
mvn dependency:analyze
```

### Servlet API

```xml
<scope>provided</scope>
```

Tomcat supplies the API at runtime.

---

## Part III – Docker

### Dockerfile

```dockerfile
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/apartment-management.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
```

If the project actually produces a WAR, use the Tomcat Dockerfile pattern instead.

### Build

```bash
docker build -t apartmentapp-image .
```

### Run

```bash
docker run -d \
  --name apartment-app-container \
  -p 8080:8080 \
  apartmentapp-image
```

### Running/all containers

```bash
docker ps
docker ps -a
```

### Enter shell

```bash
docker exec -it apartment-app-container sh
```

### Stop/restart

```bash
docker stop apartment-app-container
docker start apartment-app-container
```

### Save state as image

```bash
docker commit 0e993d2009a1 <your_dockerhub_username>/apartmentapp:v1
```

### Docker Hub login/push/logout

```bash
docker login
docker push <your_dockerhub_username>/apartmentapp:v1
docker logout
```

---

# 9. HIGH-FREQUENCY COMMANDS – MEMORIZE THESE

## Git

| Task | Command |
|---|---|
| Clone | `git clone <URL>` |
| Initialize | `git init` |
| Status | `git status` |
| Add one file | `git add file` |
| Add all | `git add .` |
| Commit | `git commit -m "message"` |
| Push | `git push origin main` |
| First push | `git push -u origin branch` |
| Remote URL | `git remote -v` |
| Rename remote | `git remote rename origin new-name` |
| Current branch | `git branch --show-current` |
| All branches | `git branch -a` |
| Create + switch | `git switch -c branch` |
| Switch | `git switch main` |
| Fetch | `git fetch origin` |
| Pull | `git pull origin main` |
| Diff | `git diff` |
| Staged diff | `git diff --cached` |
| History | `git log` |
| Compact history | `git log --oneline -4` |
| Graph | `git log --oneline --graph --decorate --all` |
| Blame | `git blame file` |
| Restore file | `git restore file` |
| Unstage | `git restore --staged file` |
| Stash | `git stash` |
| Stash list | `git stash list` |
| Restore stash | `git stash pop` |
| Rebase | `git rebase origin/main` |
| Abort rebase | `git rebase --abort` |
| Merge | `git merge branch` |
| Safe undo commit | `git revert <id>` |
| Undo commit, keep staged | `git reset --soft HEAD~1` |
| Remove tracked file but keep local | `git rm --cached file` |
| Delete merged branch | `git branch -d branch` |
| Force delete branch | `git branch -D branch` |
| Amend previous commit | `git commit --amend --no-edit` |

## Maven

| Task | Command |
|---|---|
| Maven/JDK info | `mvn -version` |
| Validate | `mvn validate` |
| Clean | `mvn clean` |
| Compile | `mvn compile` |
| Test compile | `mvn test-compile` |
| Run tests | `mvn test` |
| Package | `mvn package` |
| Full build/install | `mvn clean install` |
| Skip test execution | `mvn package -DskipTests` |
| Skip test compile + execution | `mvn package -Dmaven.test.skip=true` |
| Ignore failed tests | `mvn package -Dmaven.test.failure.ignore=true` |
| Dependency tree | `mvn dependency:tree` |
| Dependency analysis | `mvn dependency:analyze` |
| Resolve dependencies | `mvn dependency:resolve` |
| Effective POM | `mvn help:effective-pom` |
| Debug log | `mvn -X clean package` |
| One test class | `mvn -Dtest=TestClass test` |
| Install local JAR | `mvn install:install-file ...` |

## Docker

| Task | Command |
|---|---|
| Build image | `docker build -t image-name .` |
| List images | `docker images` |
| Run background | `docker run -d --name c image` |
| Port mapping | `docker run -p HOST:CONTAINER image` |
| Running containers | `docker ps` |
| All containers | `docker ps -a` |
| Logs | `docker logs c` |
| Follow logs | `docker logs -f c` |
| Shell | `docker exec -it c sh` |
| Stop | `docker stop c` |
| Start | `docker start c` |
| Remove | `docker rm c` |
| Force remove | `docker rm -f c` |
| Pull image | `docker pull image` |
| Tag | `docker tag image user/repo:tag` |
| Login | `docker login` |
| Push | `docker push user/repo:tag` |
| Logout | `docker logout` |
| Commit container → image | `docker commit container user/repo:tag` |
| Cleanup | `docker system prune` |
| Aggressive cleanup | `docker system prune -a` |
| RAM limit | `docker run --memory=512m ...` |

---

# 10. POM QUESTIONS WHERE YOU MUST INSPECT THE ACTUAL PROJECT

Several papers intentionally ask things like:

> "Identify all errors in the provided `pom.xml`."

or:

> "What is the exact generated WAR filename?"

or:

> "What is the context path?"

or:

> "Install the vendor JAR using the coordinates specified in the POM."

### Do NOT guess these.

When you get the repository in the lab:

### Step 1 — open POM

```bash
notepad pom.xml
```

or open it in Eclipse.

### Step 2 — validate

```bash
mvn validate
```

### Step 3 — inspect effective POM

```bash
mvn help:effective-pom
```

### Step 4 — inspect dependencies

```bash
mvn dependency:tree
```

### Step 5 — inspect Java/Maven environment

```bash
mvn -version
```

### Step 6 — debug if necessary

```bash
mvn -X clean package
```

### Step 7 — determine artifact name

Look for:

```xml
<artifactId>NAME</artifactId>
<version>VERSION</version>
<packaging>war</packaging>
```

Default:

```text
NAME-VERSION.war
```

But if you see:

```xml
<finalName>CUSTOM</finalName>
```

the file is:

```text
CUSTOM.war
```

### Step 8 — determine Tomcat context path

Search the POM for:

```text
<path>
```

or:

```text
<path>/something</path>
```

Then the URL is normally:

```text
http://localhost:8080/something
```

---

# 11. THE MOST IMPORTANT DIFFERENCES THEY LOVE TO ASK

## `git fetch` vs `git pull`

```text
fetch = download remote information only
pull  = fetch + integrate into current branch
```

## `git restore` vs `git restore --staged`

```text
git restore file
→ throw away working-directory changes

git restore --staged file
→ unstage file but keep its changes
```

## `git revert` vs `git reset`

```text
revert
→ creates a NEW commit undoing an old commit
→ safe for shared/public history

reset
→ moves branch pointer
→ can rewrite history
```

## `git reset --soft HEAD~1`

```text
removes last commit
keeps changes
keeps them staged
```

## `git stash`

```text
temporarily stores uncommitted work
without creating a normal commit
```

## `git rebase`

```text
moves/replays your feature commits on top of another branch
→ cleaner/linear history
```

## `git merge`

```text
combines histories
→ may create a merge commit
```

## Maven `package` vs `install`

```text
package
→ creates JAR/WAR in target/

install
→ package + installs artifact into ~/.m2/repository
```

## `-DskipTests` vs `-Dmaven.test.skip=true`

```text
-DskipTests
→ don't RUN tests
→ test compilation still happens

-Dmaven.test.skip=true
→ don't compile or run tests
```

## Docker `EXPOSE` vs `-p`

```text
EXPOSE 8080
→ documents intended container port

-p 8080:8080
→ actually maps host port 8080 to container port 8080
```

## Docker image vs container

```text
image = blueprint
container = running instance of image
```

---

# 12. FAST END-TO-END LAB FLOWS

## Maven web application → WAR → Docker → GitHub

```bash
git clone <URL>
cd <project>

mvn validate
mvn dependency:tree
mvn clean package

dir target

git init
git add .
git commit -m "Initial project"

git branch -M main
git remote add origin <YOUR_REPO>
git push -u origin main

docker build -t myapp .
docker run -d --name myapp-container -p 8080:8080 myapp
docker ps
docker logs myapp-container
```

## Feature workflow

```bash
git switch -c feature/my-feature

# edit files

git status
git diff
git add .
git commit -m "Add feature"

git fetch origin
git rebase origin/main

# if conflict:
# edit files
git add .
git rebase --continue

git push -u origin feature/my-feature
```

## Merge feature

```bash
git switch main
git pull origin main
git merge feature/my-feature
git push origin main
```

## Emergency with unfinished work

```bash
git stash
git switch main

# fix emergency
git add .
git commit -m "Hotfix"

git switch feature/my-feature
git stash pop
```

---

# 13. FINAL EXAM STRATEGY

If the examiner gives you a practical task, don't randomly type commands.

Use this order:

```text
1. cd into project
2. inspect files
3. validate POM
4. dependency tree
5. fix POM
6. mvn clean package
7. check target/
8. Git status
9. Git add
10. Git commit
11. Git remote -v
12. Git push
13. Docker build
14. Docker run
15. docker ps
16. docker logs / docker exec if needed
```

### If something fails

**Maven:**

```bash
mvn -X clean package
```

**Dependencies:**

```bash
mvn dependency:tree
```

**Git:**

```bash
git status
```

**Docker:**

```bash
docker ps -a
docker logs <container>
```

Those four commands will save your ass surprisingly often.

---

# Source / Set Mapping

| Actual paper/application | Uploaded file |
|---|---|
| Set 1 – Metro Booking System | `Set-1 (2).docx` |
| Set 2 – Car Booking System | `Set-2 (2).docx` |
| Set III – Online Boutique Store | `Set-4 (2).docx` |
| Set 1 – Online Vehicle Rental | `Set-5 (1).docx` |
| Set II – Online Event Management System | `Set-6 (1).docx` |
| Set 1 – Sports Management System | `SET-7 (1).doc` |
| Set 3 – Blood Bank Management System | `SET-8.doc` |
| Set 2 – Apartment Management System | `SET-9.doc` |

**Note:** Several uploaded papers reuse the same internal set number (for example, multiple papers are labelled "SET-1"). This README therefore identifies each one by **application name + source filename**, which is much safer during the lab.
