local PipelineBuild(os='linux', arch='amd64') = {
  local tag = os + '-' + arch,
  local version_tag = os + '-' + arch,
  local file_suffix = std.strReplace(version_tag, '-', '.'),
  kind: "pipeline",
  name: version_tag,
  platform: {
    os: os,
    arch: arch,
  },
  steps: [
    {
      name: 'dryrun',
      image: 'plugins/docker:' + tag,
      pull: 'always',
      settings: {
        dry_run: true,
        tags: version_tag,
        dockerfile: './Dockerfile.' + file_suffix,
        repo: ' xoxys/ttrss',
        username: { from_secret: "docker_username" },
        password: { from_secret: "docker_password" },
        build_args: {
          TTRSS_ORG_VERSION: "${DRONE_TAG##v}",
          TTRSS_VERSION: "${TTRSS_ORG_VERSION%.*}",
        },
      },
    },
    {
      name: 'publish',
      image: 'plugins/docker:' + tag,
      pull: 'always',
      settings: {
        auto_tag: true,
        auto_tag_suffix: version_tag,
        dockerfile: './Dockerfile.' + file_suffix,
        repo: ' xoxys/ttrss',
        username: { from_secret: "docker_username" },
        password: { from_secret: "docker_password" },
        build_args: {
          TTRSS_ORG_VERSION: "${DRONE_TAG##v}",
          TTRSS_VERSION: "${TTRSS_ORG_VERSION%.*}",
        },
      },
      when: {
        ref: [
          'refs/heads/master',
          'refs/tags/**',
        ],
      },
    },
  ],
};

local PipelineNotifications(depends_on=[]) = {
  kind: "pipeline",
  name: "notifications",
  platform: {
    os: "linux",
    arch: "amd64",
  },
  steps: [
    {
      image: "plugins/manifest",
      name: "manifest",
      pull: "always",
      settings: {
        auto_tag: true,
        ignore_missing: true,
        username: { from_secret: "docker_username" },
        password: { from_secret: "docker_password" },
        spec: "./manifest.tmpl",
      },
      when: {
        ref: [
          'refs/heads/master',
          'refs/tags/**',
        ],
      },
    },
    {
      name: "readme",
      image: "sheogorath/readme-to-dockerhub",
      pull: "always",
      environment: {
        DOCKERHUB_USERNAME: { from_secret: "docker_username" },
        DOCKERHUB_PASSWORD: { from_secret: "docker_password" },
        DOCKERHUB_REPO_PREFIX: "xoxys",
        DOCKERHUB_REPO_NAME: "ttrss",
        README_PATH: "README.md",
        SHORT_DESCRIPTION: "Tiny Tiny RSS - Free and open source news feed reader and aggregator"
      },
      when: {
        ref: [
          'refs/heads/master',
          'refs/tags/**',
        ],
      },
    },
    {
      name: "microbadger",
      image: "plugins/webhook",
      pull: "always",
      settings: {
        urls: { from_secret: "microbadger_url" },
      },
    },
    {
      image: "plugins/matrix",
      name: "matrix",
      pull: 'always',
      settings: {
        homeserver: "https://matrix.rknet.org",
        roomid: "MtidqQXWWAtQcByBhH:rknet.org",
        template: "Status: **{{ build.status }}**<br/> Build: [{{ repo.Owner }}/{{ repo.Name }}]({{ build.link }}) ({{ build.branch }}) by {{ build.author }}<br/> Message: {{ build.message }}",
        username: { from_secret: "matrix_username" },
        password: { from_secret: "matrix_password" },
      },
      when: {
        status: [ "success", "failure" ],
      },
    },
  ],
  trigger: {
    status: [ "success", "failure" ],
  },
  depends_on: depends_on,
};

[
  PipelineBuild(os='linux', arch='amd64'),
  PipelineNotifications(depends_on=[
    "linux-amd64",
  ])
]
