#!/bin/bash

echo "#!/bin/bash" > ./prep_maven_repo.sh

find ~/.gradle/caches/modules-2/files-2.1/ -name "*.pom" -exec bash -c 'base=$(echo ${1/"$HOME/.gradle/caches/modules-2/files-2.1/"/ }) && group=$(echo $base | cut -d "/" -f 1 | tr . /) && name=$(echo $base | cut -d "/" -f 2) && version=$(echo $base | cut -d "/" -f 3) && echo "mkdir -p ./mavenLocal/$group/$name/$version" >> ./prep_maven_repo.sh' bash {} \;

chmod +x ./prep_maven_repo.sh
