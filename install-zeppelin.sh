#!/usr/bin/env bash

set -e
set -o pipefail

# iptables does not exists in this container
# echo "Disable ipatbles"
# sudo service iptables stop
# sudo chkconfig iptables off

pushd /usr/local/
  if [ ! -d zeppelin ]; then

    echo "Downloading Zeppelin..."
    wget http://archive.apache.org/dist/zeppelin/zeppelin-0.7.2/zeppelin-0.7.2-bin-netinst.tgz
    tar -xzf zeppelin-0.7.2-bin-netinst.tgz
    rm -rf zeppelin-0.7.2-bin-netinst.tgz
    mv zeppelin-0.7.2-bin-netinst zeppelin

    pushd zeppelin

      echo "List Interpreters..."
      ./bin/install-interpreter.sh  -l

      REQUIRED_INTERPRETERS=file,hbase,md,shell,python,pig
      echo "Install Interpreters: $REQUIRED_INTERPRETERS"
      ./bin/install-interpreter.sh  -n $REQUIRED_INTERPRETERS

      echo "Update Interpreters..."
      cat conf/zeppelin-site.xml.template > conf/zeppelin-site.xml
      echo '[ -f /etc/profile.d/bigbox.sh ] && . /etc/profile.d/bigbox.sh' > conf/zeppelin-env.sh
      cat conf/zeppelin-env.sh.template >> conf/zeppelin-env.sh

    popd # /usr/local/

    (! id -u zeppelin > /dev/null 2>&1 ) && adduser zeppelin
    chown -R zeppelin:zeppelin zeppelin
    sudo -u hdfs hdfs dfs -mkdir -p /user/zeppelin
    sudo -u hdfs hdfs dfs -chown -R zeppelin:zeppelin /user/zeppelin

    echo "Zeppelin is Ready Now!"
    echo "Please use this command to start your service: "
    echo "sudo -u zeppelin /usr/local/zeppelin/bin/zeppelin-daemon.sh start"
    echo "Please use this command to stop your service: "
    echo "sudo -u zeppelin /usr/local/zeppelin/bin/zeppelin-daemon.sh stop"

  else

    echo "DIR: /usr/local/zeppelin detected, stop the installing progress"
    echo "This used to prevent this script executed twice"
    echo "If this folder is installed by yourself, please erase it first"

  fi

popd # /