'use strict';

const fs = require('fs');

const normalizeBranchName = (branch) => {
    // characters allowed by docker tag more limited than git branch name
    branch = branch.replace(/[^A-Za-z0-9_]/g, '_');
    const limit = 96; // 128 - 'branch-.time-20170324_180038_UTC'.length
    if (branch.length > limit) {
        branch = branch.substr(0, limit);
    }
    return branch;
};

const expectedBranchPrefix = 'origin/';
let branch = process.env.GIT_BRANCH.substr(expectedBranchPrefix.length);
branch = normalizeBranchName(branch);

fs.writeFileSync('./setDockerEnv.sh', `#!/usr/bin/env bash
export DOCKER_BRANCH=${branch}
export DOCKER_VERSION=${require(`${process.cwd()}/package.json`).version}
`);
