---

# APPENDIX — GYM `pom.xml` PROVIDED SEPARATELY
**File name: `pom.xml`**  
**Note:** The Gym POM supplied separately is already structurally valid.

Its important values are:

```xml
<groupId>KMIT</groupId>
<artifactId>GymManagementSystem</artifactId>
<version>0.0.1-SNAPSHOT</version>
<packaging>war</packaging>
```

and it already uses valid plugin versions such as:

```xml
<maven-compiler-plugin>3.13.0</maven-compiler-plugin>
<maven-war-plugin>3.4.0</maven-war-plugin>
```

The only potentially exam-dependent value is:

```xml
<maven.compiler.source>8</maven.compiler.source>
<maven.compiler.target>8</maven.compiler.target>
```

If the question specifically requires Java 17, change both `8` values to `17`. Otherwise, **do not change this POM unnecessarily**.

**Important:** Gym is not one of the numbered Set 1–9 POMs in the supplied set list, so it is included here as a clearly labelled extra appendix rather than being mixed into another set.
