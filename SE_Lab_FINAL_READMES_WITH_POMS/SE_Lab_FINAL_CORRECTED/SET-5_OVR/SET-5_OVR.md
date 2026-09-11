# SET-5 — Online Vehicle Rental (OVR)

> **Exam order:** Maven → Git/GitHub → Docker.\
**Actual question name (short):** OVR
> Repository: `https://github.com/haleema91/Internal-1-OVR.git`

## PART I --- MAVEN

### 1. Clone

``` bash
git clone https://github.com/haleema91/Internal-1-OVR.git
cd Internal-1-OVR
```

### 2. Identify POM errors

Open `pom.xml` and inspect:

``` text
groupId
artifactId
version
packaging
dependencies
plugins
compiler configuration
```


### 2. Check `pom.xml` — COMPLETE CORRECTED POM

**File name:** `pom.xml`  
**Set:** SET-5 — Online Vehicle Rental (OVR)  
**Short question name:** OVR

Copy/replace the contents of the project's `pom.xml` with the following corrected code:

```xml
<?xml version="1.0" encoding="UTF-8"?>

<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>kmitlab</groupId>
    <artifactId>OVR</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <name>OVR</name>
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
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.13.0</version>
                </plugin>
                <plugin>
                    <artifactId>maven-resources-plugin</artifactId>
                    <version>3.3.1</version>
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


### 3. Build/run

``` bash
mvn clean install
```

### 4. Convert WAR → JAR

Change:

``` xml
<packaging>war</packaging>
```

to:

``` xml
<packaging>jar</packaging>
```

If it must be executable, configure an executable-JAR plugin and ensure
a `main()` method exists.

### 5. PostgreSQL JDBC dependency

Add the PostgreSQL JDBC dependency with the required Maven coordinates
in `pom.xml`.

Then resolve/build:

``` bash
mvn dependency:resolve
mvn clean package
```

### 6. JUnit version

Add the required version:

``` xml
<dependency>
    <groupId>...</groupId>
    <artifactId>...</artifactId>
    <version>...</version>
    <scope>test</scope>
</dependency>
```

Then:

``` bash
mvn test
```

### 7. Skip tests

``` bash
mvn package -DskipTests
```

### 8. Build and inspect `target/`

``` bash
mvn clean install
dir target
```

### 9. Unsupported class version

Inspect Java/compiler configuration and Maven compiler plugin.

Check environment:

``` bash
java -version
javac -version
mvn -version
```

Then inspect/update the compiler settings in `pom.xml` and rebuild:

``` bash
mvn clean package
```

### 10. Push to GitHub

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

### 1. Initialize

``` bash
git init
```

### 2. Configure username/email

``` bash
git config --global user.name "rentaldev"
git config --global user.email "dev@rental.com"
```

### 3. Stage `VehicleService.java`

``` bash
git add VehicleService.java
```

### 4. Commit

``` bash
git commit -m "Added Vehicle Management Module"
```

### 5. Inspect `VehicleController.java`

``` bash
git diff VehicleController.java
```

### 6. Complete commit history

``` bash
git log
```

### 7. Unstage `application.properties`

``` bash
git restore --staged application.properties
```

### 8. Discard uncommitted `RentalService.java` changes

``` bash
git restore RentalService.java
```

### 9. Create branch

``` bash
git switch -c vehicle-booking
```

### 10. Rebase feature onto latest main

``` bash
git fetch origin
git switch vehicle-booking
git rebase origin/main
```

### 11. Payment branch is behind main

``` bash
git fetch origin
git switch payment
git rebase origin/main
```

If conflicts occur:

``` bash
git status
```

Resolve → stage:

``` bash
git add <file>
git rebase --continue
```

### 12. Switch back to main

``` bash
git switch main
```

------------------------------------------------------------------------

## PART III --- DOCKER

### 1. Dockerfile

``` dockerfile
FROM tomcat:9

COPY target/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

### 2. Build and run OVR

``` bash
docker build -t OVR .
docker run -d --name ovr-container -p 8080:8080 OVR
```

### 3. Active containers

``` bash
docker ps
```

### 4. Stop running container

``` bash
docker stop ovr-container
```

### 5. View logs

``` bash
docker logs ovr-container
```

### 6. View all images

``` bash
docker images
```

### 7. Tag and push to Docker Hub

``` bash
docker login
docker tag OVR <dockerhub-username>/OVR:latest
docker push <dockerhub-username>/OVR:latest
```

------------------------------------------------------------------------

# QUICK EXAM ORDER

``` bash
git clone https://github.com/haleema91/Internal-1-OVR.git
cd Internal-1-OVR

mvn clean install
dir target

git init
git config --global user.name "rentaldev"
git config --global user.email "dev@rental.com"
git add .
git commit -m "Initial commit"
git remote add origin <URL>
git push -u origin main

docker build -t OVR .
docker run -d --name ovr-container -p 8080:8080 OVR
docker ps
docker logs ovr-container
docker images
docker login
docker tag OVR <username>/OVR:latest
docker push <username>/OVR:latest
```
