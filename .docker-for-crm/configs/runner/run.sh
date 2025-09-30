#/usr/local/bin/gitlab-runner start
#sudo /usr/bin/dockerd &
cat /home/gitlab-runner/config.toml-example | sed -e "s/RUNNER_ID/$RUNNER_ID/g" | sed -e "s/RUNNER_TOKEN/$RUNNER_TOKEN/g" > /home/gitlab-runner/.gitlab-runner/config.toml
/usr/local/bin/gitlab-runner run