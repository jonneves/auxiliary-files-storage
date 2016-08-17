#!/bin/bash

############################################################
############################################################
#### Autor: Jonatan Neves <jonatan.neves@senior.com.br> ####
#### Descrição: Recupera a última versão de um artefato ####
#### Parâmetros:                                        ####
####	1) GroupID - Ex. com.senior.platform            ####
####    2) ArtifactID - Ex. plataforma-acesso-frontend  ####
####    3) Extension - Ex. war                          ####
####                                                    ####
############################################################
############################################################


echo "

      ############################################################
      #### Autor: Jonatan Neves <jonatan.neves@senior.com.br> ####
      #### Descrição: Recupera a última versão de um artefato ####
      #### Parâmetros:                                        ####
      ####    1) GroupID - Ex. com.senior.platform            ####
      ####    2) ArtifactID - Ex. plataforma-acesso-frontend  ####
      ####    3) Extension - Ex. war                          ####
      ####                                                    ####
      ############################################################
      ############################################################

"
# Validando a entrada de dados
if [ "$#" -lt "3" ]
  then
    echo "
          >>> Atenção: Verifique os parâmetros
        "
    echo ">>> Uso: "
    echo ">>> ./get_latest.sh \$groupId \$artifactId \$extension"
    exit 1
fi



# Endereço do servidor
server=http://maven.senior.com.br:8081/artifactory

# Nome do repositório
repo=libs-release-local

# GAVC - Informações do Repositório
groupId=$1
artifactId=$2

# Acertando o caminho para o artifactory

replace_dot=/
groupIdPath="${groupId//[.]/$replace_dot}"

artifact=$groupIdPath/$2


# Buscando as informações no servidor

path=$server/$repo/$artifact
version=`curl -s $path/maven-metadata.xml | grep release | sed "s/.*<release>\([^<]*\)<\/release>.*/\1/"`
build=`curl -s $path/$version/maven-metadata.xml | grep '<value>' | head -1 | sed "s/.*<value>\([^<]*\)<\/value>.*/\1/"`


if [[ ! -z "${build// }" ]]
  then
    echo "Usando a última Build: $build"    
    binary=$actifactId-$build.$3
else
    binary=$artifactId-$version.$3
fi

url=$path/$version/$binary

# Download
echo "
	Realizando o download do seguinte artefato
		>>>> $url <<<<
"

wget -N $url
