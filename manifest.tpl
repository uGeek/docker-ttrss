image: xoxys/ttrss:{{#if build.tag}}{{trimPrefix "v" build.tag}}{{else}}latest{{/if}}
{{#if build.tags}}
tags:
{{#each build.tags}}
  - {{this}}
{{/each}}
{{/if}}
manifests:
  -
    image: plugins/ansible:{{#if build.tag}}{{trimPrefix "v" build.tag}}-{{/if}}linux-amd64
    platform:
      architecture: amd64
      os: linux
