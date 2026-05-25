The name conflict is because a stopped container named `sonar` already exists.

Use:

```bash
docker ps -a | grep sonar
```

Then remove it if you don’t need it:

```bash
docker rm sonar
```

Or rename it instead:

```bash
docker rename sonar sonar-old
```

After that, rerun:

```bash
docker run -d --name sonar -p 9000:9000 sonarqube:community
```