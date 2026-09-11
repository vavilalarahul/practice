# SET-1 — Metro Booking System

> **Exam order in this paper:** Maven → Git/GitHub → Docker.\
**Actual question name (short):** Metro Booking
> Repository: `https://github.com/anujyog1/MetroRepo.git`

## PART I --- MAVEN (40M)

### Q1. Clone the project

``` bash
git clone https://github.com/anujyog1/MetroRepo.git
cd MetroRepo
```

### Q2. Resolve dependencies using `pom.xml`

1.  Open `pom.xml`.
2.  Check `<groupId>`, `<artifactId>`, `<version>`, `<packaging>`.
3.  Check every `<dependency>` for correct coordinates and a version
    where required.
4.  If a dependency is unwanted, inspect the dependency tree first:

``` bash
mvn dependency:tree
```

### 2. Check `pom.xml` — COMPLETE CORRECTED POM

**File name:** `pom.xml`  
**Set:** SET-1 — Metro Booking System  
**Short question name:** Metro Booking

Copy/replace the contents of the project's `pom.xml` with the following corrected code:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>SEGroup</groupId>
    <artifactId>book-metro-ticket</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>war</packaging>

    <dependencies>

        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
            <scope>provided</scope>
        </dependency>

        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>

    </dependencies>

    <build>
        <finalName>book-metro-ticket</finalName>
    </build>

</project>
```


### Q3. Build the project and generate WAR/JAR

For a clean build:

``` bash
mvn clean install
```

For only packaging:

``` bash
mvn clean package
```

Check the generated artifact:

``` bash
dir target
```

The artifact is normally inside `target/`.

### Q4. Convert WAR to standalone JAR

In `pom.xml`, change:

``` xml
<packaging>war</packaging>
```

to:

``` xml
<packaging>jar</packaging>
```

For a truly executable JAR, the application also needs a `main()` method
and an appropriate Maven plugin. Do not remove web-specific dependencies
unless the application no longer needs them.

### Q5. Dependency not recognized by compiler

Check the dependency tree:

``` bash
mvn dependency:tree
```

Check Maven's local repository:

``` text
C:\Users\<username>\.m2\repository
```

Then refresh/rebuild:

``` bash
mvn clean compile
```

### Q6. Maven web project / WAR structure

Typical structure:

``` text
project/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/
│   │   ├── resources/
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── web.xml
│   └── test/
└── target/
```

Use:

``` xml
<packaging>war</packaging>
```

Package:

``` bash
mvn clean package
```

### Q7. Production profile + skip tests

Build with the production profile and skip test execution:

``` bash
mvn clean package -Pprod -DskipTests
```

### Q8. Full dependency hierarchy

``` bash
mvn dependency:tree
```

### Q9. Compile vs package

``` text
compile  → compiles source into .class files
package  → packages the compiled project into JAR/WAR
```

### Q10. Old files in `target/`

Run:

``` bash
mvn clean
```

Then rebuild:

``` bash
mvn package
```

------------------------------------------------------------------------

## PART II --- GIT & GITHUB (40M)

### Q1. Initialize repository

From the project root:

``` bash
git init
git add .
git commit -m "Initial commit"
```

### Q2. Configure Git and push

``` bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

git remote add origin <YOUR_GITHUB_REPOSITORY_URL>
git branch -M main
git push -u origin main
```

### Q3. Temporarily save unfinished work

``` bash
git stash
git switch main
```

Fix the bug:

``` bash
git add .
git commit -m "Fix critical bug"
git push origin main
```

Return to feature branch:

``` bash
git switch <feature-branch>
git stash list
git stash pop
```

### Q4. Merge conflict

``` bash
git status
```

Open every conflicted file and resolve:

``` text
<<<<<<< HEAD
your changes
=======
other branch changes
>>>>>>> branch-name
```

After resolving:

``` bash
git add <conflicted-file>
git commit -m "Resolve merge conflict"
```

Push:

``` bash
git push origin <branch-name>
```

### Q5(a). Verify remote and rename `origin`

``` bash
git remote -v
git remote rename origin metro-origin
git remote -v
```

### Q5(b). Create feature branch directly from `main`

``` bash
git switch -c feature/fare-calculator main
```

### Q5(c). Same-line conflict in `TicketController.java`

``` bash
git switch feature/qr-scanner
git merge main
git status
```

Resolve the conflict in `TicketController.java`, keeping the required QR
validation changes.

``` bash
git add TicketController.java
git commit -m "Resolve QR validation conflict"
```

### Q5(d). Bad commit already pushed

Use `revert`, not history rewriting:

``` bash
git revert <BAD_COMMIT_HASH>
git push origin main
```

### Q5(e). Find who changed a particular line

``` bash
git blame FareMatrix.json
```

For a specific range:

``` bash
git blame -L <start>,<end> FareMatrix.json
```

### Q5(f). Push modified `register.jsp`

``` bash
git status
git diff
git add register.jsp
git commit -m "Update register page"
git push origin <current-branch>
```

### Q5(g). Wrong pushed change --- keep history clean

``` bash
git revert <BAD_COMMIT_HASH>
git push origin main
```

### Q5(h). Unstage secret file without deleting it

``` bash
git restore --staged db_passwords.env
```

Check:

``` bash
git status
```

### Q5(i). Who last modified `login.jsp`?

``` bash
git log -1 -- login.jsp
```

### Q5(j). Full details of last commit

``` bash
git show HEAD
```

------------------------------------------------------------------------

## PART III --- DOCKER (20M)

### Q1. Dockerfile

For a WAR/JAR application running on Tomcat, the exact base/runtime
depends on the project. A standard pattern is:

``` dockerfile
FROM tomcat:9

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

### Q2. Build and run

Build:

``` bash
docker build -t metro-app .
```

Run:

``` bash
docker run -d --name metro-app-container -p 8080:8080 metro-app
```

Check:

``` bash
docker ps
```

### Q3(a). PostgreSQL database container

``` bash
docker run -d --name metro-db -p 5432:5432 postgres
```

### Q3(b). Host port 80 → Tomcat 8082

``` bash
docker run -d --name metro-app -p 80:8082 metro-app
```

### Q3(c). View real-time logs

``` bash
docker logs -f metro-applogs
```

If the container name is different, use that actual name.

### Q3(d). Update container after rebuilding WAR

``` bash
mvn clean package
docker build -t metro-app .
docker stop metro-app
docker rm metro-app
docker run -d --name metro-app -p 8080:8080 metro-app
```

### Q3(e). Interactive terminal

``` bash
docker exec -it <container-name> /bin/bash
```

### Q3(f). Remove unused Docker resources

``` bash
docker system prune
```

### Q3(g). Run in background

``` bash
docker run -d --name metro-app -p 8080:8080 metro-app
```

### Q3(h). Force stop and remove in one line

``` bash
docker rm -f metro-app
```

------------------------------------------------------------------------

# QUICK EXAM COMMAND ORDER

``` bash
git clone https://github.com/anujyog1/MetroRepo.git
cd MetroRepo

mvn dependency:tree
mvn clean install
dir target

git init
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git add .
git commit -m "Initial commit"
git remote add origin <URL>
git branch -M main
git push -u origin main

docker build -t metro-app .
docker run -d --name metro-app-container -p 8080:8080 metro-app
docker ps
docker logs metro-app-container
```
