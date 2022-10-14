#!/bin/bash

#Cargamos las variables de la VPC
REGION=$(cat variables.txt | grep REGION | cut -d"=" -f2)
PROJECT=$(cat variables.txt | grep PROJECT | cut -d"=" -f2)
LCPROJECT=$(echo ${PROJECT} | tr [[:upper:]] [[:lower:]])
VPC_ID=$(cat variables.txt | grep VPC_ID | cut -d"=" -f2)
CIRDVPC=$(cat variables.txt | grep CIRDVPC | cut -d"=" -f2)
BBDD_SUBNET_AZA=$(cat variables.txt | grep PRIVATE_SUBNET_AZA | cut -d"=" -f2)
BBDD_SUBNET_AZB=$(cat variables.txt | grep PRIVATE_SUBNET_AZB | cut -d"=" -f2)
BBDD_SUBNET_AZC=$(cat variables.txt | grep PRIVATE_SUBNET_AZC | cut -d"=" -f2)

function header () {
        echo "###################################################"
        echo "#                                                 #"
        echo "#   AWS CREATE RDS AURORA SCRIPT AUTOMATION       #"
        echo "#                                                 #"
        echo "###################################################"
        loadValues
}
function loadValues () {
    echo -ne "ENTER THE VALUE FOR ADMIN USER BBDD: "
    read ADMINUSERBBDD

    echo -ne "ENTER THE VALUE FOR PASSWORD ADMIN USER BBDD (minimum 8 characters): "
    read ADMINPASSWDBBDD
    sgRds
}

function sgRds () {
    SG_AURORA_ID=$(aws ec2 create-security-group \
                --region $REGION \
                --group-name SG-Aurora-${PROJECT} \
                --description "Amazon Aurora SG for VPC Access" \
                --vpc-id ${VPC_ID} | jq -r '.GroupId')

        aws ec2 create-tags \
                --resources ${SG_AURORA_ID} \
                --tags Key=Name,Value=SG-Aurora-${PROJECT} \
                --region ${REGION}


        aws ec2 authorize-security-group-ingress \
                --group-id ${SG_AURORA_ID} \
                --protocol tcp \
                --port 3306 \
                --cidr ${CIRDVPC} \
                --region ${REGION}
        createSubnetGroup
}

function createSubnetGroup () {
    aws rds create-db-subnet-group \
        --db-subnet-group-name sg-${LCPROJECT} \
        --db-subnet-group-description "The SubnetGroup Aurora RDS Cluster" \
        --subnet-ids "${BBDD_SUBNET_AZA}" "${BBDD_SUBNET_AZB}" "${BBDD_SUBNET_AZC}" \
        --tags Key=Name,Value=sg-${LCPROJECT} \
        --region ${REGION}
    createClusterParametersGroup
}

function createClusterParametersGroup () {
    aws rds create-db-cluster-parameter-group \
        --db-cluster-parameter-group-name pg-cluster-${LCPROJECT} \
        --db-parameter-group-family aurora-mysql5.7 \
        --description "Parameters Group Cluster Aurora" \
        --tags Key=Name,Value=pg-cluster-${LCPROJECT} \
        --region ${REGION}
    createParametersGroup
}

function createParametersGroup () {
    aws rds create-db-parameter-group \
        --db-parameter-group-name pg-${LCPROJECT} \
        --db-parameter-group-family aurora-mysql5.7 \
        --description "Parameters Group DB Aurora" \
        --tags Key=Name,Value=pg-${LCPROJECT} \
        --region ${REGION}
    createOptionsGroup
}

function createOptionsGroup () {
    aws rds create-option-group \
        --option-group-name og-${LCPROJECT} \
        --engine-name aurora-mysql \
        --major-engine-version 5.7 \
        --option-group-description "Options Group DB Aurora" \
        --tags Key=Name,Value=og-${LCPROJECT} \
        --region ${REGION}
    createAuroraCluster
}
function createAuroraCluster () {
    CLUSTERINFO=$(aws rds create-db-cluster \
        --availability-zones ${REGION}a ${REGION}b ${REGION}c \
        --backup-retention-period 15 \
        --database-name ${LCPROJECT} \
        --db-cluster-identifier cluster-${LCPROJECT} \
        --db-cluster-parameter-group-name pg-cluster-${LCPROJECT} \
        --vpc-security-group-ids ${SG_AURORA_ID} \
        --db-subnet-group-name sg-${LCPROJECT} \
        --engine aurora-mysql \
        --engine-version 5.7.12 \
        --port 3306 \
        --enable-cloudwatch-logs-exports '["audit","error","general","slowquery"]' \
        --master-username ${ADMINUSERBBDD} \
        --master-user-password ${ADMINPASSWDBBDD} \
        --no-deletion-protection \
        --copy-tags-to-snapshot \
        --region ${REGION})
    createAuroraWrite
}

function createAuroraWrite () {
    aws rds create-db-instance \
        --db-instance-class db.t3.small \
        --db-instance-identifier aurora-${LCPROJECT} \
        --engine aurora-mysql \
        --db-subnet-group-name sg-${LCPROJECT} \
        --db-parameter-group-name pg-${LCPROJECT} \
        --option-group-name og-${LCPROJECT} \
        --no-publicly-accessible \
        --db-cluster-identifier cluster-${LCPROJECT} \
        --region ${REGION}
    exportVar
}

function exportVar () {
    echo "WRITEENDPOINT=$(echo $CLUSTERINFO | jq -r '.DBCluster.Endpoint')" >> variables.txt
    echo "READENDPOINT=$(echo $CLUSTERINFO | jq -r '.DBCluster.ReaderEndpoint')" >> variables.txt
    echo "ADMINUSERDB=$(echo $CLUSTERINFO | jq -r '.DBCluster.MasterUsername')" >> variables.txt
    echo "ADMINPASSWDBBDD=${ADMINPASSWDBBDD}" >> variables.txt  
    echo "BBDDNAME=$(echo $CLUSTERINFO | jq -r '.DBCluster.DatabaseName')" >> variables.txt
}
header