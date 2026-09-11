# SET-4 — Online Boutique Store (OBS)

> **Exam order:** Maven → Git/GitHub → Docker.\
**Actual question name (short):** OBS
> Repository: `https://github.com/haleema91/Internal-1-OBS.git`

## PART I --- MAVEN

### 1. Clone

``` bash
git clone https://github.com/haleema91/Internal-1-OBS.git
cd Internal-1-OBS
```

### 2. Inspect/fix `pom.xml`

Check:

``` text
groupId
artifactId
version
packaging
dependencies
build/plugins
```


### 2. Check `pom.xml` — COMPLETE CORRECTED POM

**File name:** `pom.xml`  
**Set:** SET-4 — Online Boutique Store (OBS)  
**Short question name:** OBS

Copy/replace the contents of the project's `pom.xml` with the following corrected code:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>kmitlab2</groupId>
    <artifactId>OBS-Store</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <name>OBS</name>
    <url>http://www.example.com</url>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.release>17</maven.compiler.release>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.junit</groupId>
                <artifactId>junit-bom</artifactId>
                <version>5.12.0</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-params</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <artifactId>maven-clean-plugin</artifactId>
                    <version>3.4.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-resources-plugin</artifactId>
                    <version>3.3.1</version>
                </plugin>
                <plugin>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.13.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-surefire-plugin</artifactId>
                    <version>3.3.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-jar-plugin</artifactId>
                    <version>3.4.2</version>
                </plugin>
                <plugin>
                    <artifactId>maven-install-plugin</artifactId>
                    <version>3.1.2</version>
                </plugin>
                <plugin>
                    <artifactId>maven-deploy-plugin</artifactId>
                    <version>3.1.2</version>
                </plugin>
                <plugin>
                    <artifactId>maven-site-plugin</artifactId>
                    <version>3.12.1</version>
                </plugin>
                <plugin>
                    <artifactId>maven-project-info-reports-plugin</artifactId>
                    <version>3.6.1</version>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>

</project>
```


### 3. Build and run Maven project

``` bash
mvn clean package
```

For a complete install:

``` bash
mvn clean install
```

### 4. Convert WAR → standalone JAR

Change:

``` xml
<packaging>war</packaging>
```

to:

``` xml
<packaging>jar</packaging>
```

A standalone executable JAR also needs a `main()` method and suitable
executable-JAR configuration.

### 5. Add MySQL dependency

Add the MySQL JDBC dependency using the coordinates required by the
project/POM. Then download/resolve dependencies with:

``` bash
mvn dependency:resolve
```

and verify:

``` bash
mvn dependency:tree
```

### 6. Fix old Java source/target

Modify the Maven Compiler Plugin configuration in `pom.xml`.

Example Java 17 configuration:

``` xml
<properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
</properties>
```

Then:

``` bash
mvn clean compile
```

### 7. Dependency cannot be resolved

Check:

``` xml
<groupId>...</groupId>
<artifactId>...</artifactId>
<version>...</version>
```

Then:

``` bash
mvn dependency:tree
mvn clean compile
```

### 8. SNAPSHOT → release

Change:

``` xml
<version>1.0-SNAPSHOT</version>
```

to:

``` xml
<version>1.0</version>
```

`SNAPSHOT` represents a development version that can change. A release
version is treated as a stable released artifact.

### 9. Dependency tree

``` bash
mvn dependency:tree
```

### 10. Push project to GitHub

``` bash
git init
git add .
git commit -m "Initial commit"
git remote add origin <GITHUB_URL>
git branch -M main
git push -u origin main
```

------------------------------------------------------------------------

## PART II --- GIT

### 1. Check remote

``` bash
git remote -v
```

### 2. Create and switch to `product-search`

``` bash
git switch -c product-search
```

### 3. Inspect exact changes

``` bash
git diff
```

### 4. Restore `Customer.java`

``` bash
git restore Customer.java
```

### 5. Fetch without changing current branch

``` bash
git fetch origin
```

Difference:

``` text
git fetch → downloads remote updates only
git pull   → fetches + integrates remote changes
```

### 6. Update local main

``` bash
git switch main
git pull origin main
```

### 7. Rebase feature branch onto latest main

``` bash
git fetch origin
git switch product-search
git rebase origin/main
```

If conflict:

``` bash
git status
```

Resolve file, then:

``` bash
git add <file>
git rebase --continue
```

Cancel:

``` bash
git rebase --abort
```

### 8. Merge feature into main

``` bash
git switch main
git merge product-search
git push origin main
```

### 9. SSH authentication

Generate key:

``` bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

Copy the public key:

``` bash
type %USERPROFILE%\.ssh\id_ed25519.pub
```

Add it to GitHub → Settings → SSH and GPG keys.

Test:

``` bash
ssh -T git@github.com
```

### 10. Fork workflow

1.  Fork the repository on GitHub.
2.  Clone your fork:

``` bash
git clone <YOUR-FORK-URL>
cd Internal-1-OBS
```

3.  Add original repository as upstream:

``` bash
git remote add upstream <ORIGINAL-REPOSITORY-URL>
```

4.  Create a feature branch:

``` bash
git switch -c product-search
```

5.  Make changes:

``` bash
git add .
git commit -m "Add product search"
```

6.  Push to your fork:

``` bash
git push -u origin product-search
```

7.  Create a Pull Request from your fork to the original repository.

------------------------------------------------------------------------

## PART III --- DOCKER

### 1. Dockerfile

``` dockerfile
FROM tomcat:9

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

### 2. Build and run OBS

``` bash
docker build -t OBS .
docker run -d --name obs-container -p 8080:8080 OBS
```

### 3. Enter running container

``` bash
docker exec -it obs-container /bin/bash
```

Check the JAR:

``` bash
ls /usr/local/tomcat/webapps
```

### 4. Replace old container after new JAR/image

``` bash
docker build -t OBS .
docker stop obs-container
docker rm obs-container
docker run -d --name obs-container -p 8080:8080 OBS
```

### 5. Nginx on host port 8081

``` bash
docker pull nginx
docker run -d --name nginx-container -p 8081:80 nginx
```

### 6. Check which container uses port 8081

``` bash
docker ps
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/haleema91/Internal-1-OBS.git
cd Internal-1-OBS

mvn dependency:tree
mvn clean package

git init
git add .
git commit -m "Initial commit"
git remote add origin <URL>
git push -u origin main

docker build -t OBS .
docker run -d --name obs-container -p 8080:8080 OBS
docker ps
docker logs obs-container
```
