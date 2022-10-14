#!/bin/bash

function header () {
        echo "###################################################"
        echo "#                                                 #"
        echo "# AWS CREATE VPC MULTILAYER SCRIPT AUTOMATION     #"
        echo "#                                                 #"
        echo "###################################################"
        varVpc
}

function varVpc () {
        echo ""
        echo "SET THE FOLLOWING VARIABLES"
        echo "ENTER THE VALUE FOR THE AWS REGION ZONE"
        echo ""
        echo "  1) America"
        echo "  2) Europe"
        echo "  3) Asia"
        until [[ "$ZONE" =~ ^[1-3]$ ]]; do
	        read -rp "SELECTION REGION ZONE [1-3]: " -e ZONE
	done

        case $ZONE in
        1)
                echo "ENTER THE VALUE FOR THE ESPECIFIES REGION"
                echo ""
                echo "1) us-east-1 US East (N. Virginia)"
                echo "2) us-east-2 EE.UU. Este (Ohio)"
                echo "3) us-west-1 EE.UU. Oeste (Norte de California)"
                echo "4) us-west-2 EE.UU. Oeste (Oregón)"
                echo "5) ca-central-1 Canadá (Central)"
                echo "6) sa-east-1 América del Sur (São Paulo)"
                until [[ "$REGION" =~ ^[1-6]$ ]]; do
		        read -rp "ESPECIFIC REGION [1-6]: " -e REGION
	        done
                if [ $REGION = 1 ]; then
                        REGION=us-east-1
                elif [ $REGION = 2 ]; then
                        REGION=us-east-2
                elif [ $REGION = 3 ]; then
                        REGION=us-west-1
                elif [ $REGION = 4 ]; then
                        REGION=us-west-2
                elif [ $REGION = 5 ]; then
                        REGION=ca-central-1
                elif [ $REGION = 6 ]; then
                        REGION=sa-east-1
                fi
        ;;
        2)
                echo "ENTER THE VALUE FOR THE ESPECIFIES REGION"
                echo "" 
                echo "1) eu-central-1 UE (Fráncfort)"
                echo "2) eu-west-1 UE (Irlanda)"
                echo "3) eu-west-2 UE (Londres)"
                echo "4) eu-west-3 UE (París)"
                echo "5) eu-north-1 UE (Estocolmo)"
                until [[ "$REGION" =~ ^[1-5]$ ]]; do
		        read -rp "ESPECIFIC REGION [1-5]: " -e REGION
	        done
                if [ $REGION = 1 ]; then
                        REGION=eu-central-1
                elif [ $REGION = 2 ]; then
                        REGION=eu-west-1
                elif [ $REGION = 3 ]; then
                        REGION=eu-west-2
                elif [ $REGION = 4 ]; then
                        REGION=eu-west-3
                elif [ $REGION = 5 ]; then
                        REGION=eu-north-1
                fi
        ;;
        3)
                echo "ENTER THE VALUE FOR THE ESPECIFIES REGION"
                echo "" 
                echo "1) ap-east-1 Asia Pacífico (Hong Kong)"
                echo "2) ap-northeast-1 Asia Pacífico (Tokio)"
                echo "3) ap-northeast-2 Asia Pacífico (Seúl)"
                echo "4) ap-northeast-3 Asia Pacífico (Osaka-local)"
                echo "5) ap-southeast-1 Asia Pacífico (Singapur)"
                echo "6) ap-southeast-2 Asia Pacífico (Sídney)"
                echo "7) ap-south-1 Asia Pacífico (Mumbai)"
                echo "8) me-south-1 Medio Oriente (Baréin)"
                until [[ "$REGION" =~ ^[1-8]$ ]]; do
		        read -rp "ESPECIFIC REGION [1-8]: " -e REGION
	        done
                if [ $REGION = 1 ]; then
                        REGION=ap-east-1
                elif [ $REGION = 2 ]; then
                        REGION=ap-northeast-1
                elif [ $REGION = 3 ]; then
                        REGION=ap-northeast-2
                elif [ $REGION = 4 ]; then
                        REGION=ap-northeast-3
                elif [ $REGION = 5 ]; then
                        REGION=ap-southeast-1
                elif [ $REGION = 6 ]; then
                        REGION=ap-southeast-2
                elif [ $REGION = 7 ]; then
                        REGION=ap-south-1
                elif [ $REGION = 8 ]; then
                        REGION=me-south-1
                fi
                ;;
        esac
        echo "ENTER THE VALUE FOR THE PROJECT"
        read PROJECT

        echo "ENTER THE VALUE FOR THE PUBLIC SUBNET TAG NAME"
        read PUBLIC_SUBNET_NAME

        echo "ENTER THE VALUE FOR THE PRIVATE SUBNET TAG NAME"
        read PRIVATE_SUBNET_NAME

        echo "ENTER THE VALUE FOR THE DATA BASE SUBNET TAG NAME"
        read BBDD_SUBNET_NAME

        cirdVpc
}

function cirdVpc () {
        echo "ENTER THE CIRD VALUE FOR VPC SETTINGS. ( Example: 10.0.0.0/16 - 172.31.0.0/16 )"
        read -p "Input:" CIRDVPC

        if [[ $CIRDVPC =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/[0-9]+$ ]];
        then
        echo "THE CIRD DEFINED IS: $CIRDVPC"
        
        createVpc
        else
        echo "THE CIRD IS NOT VALID"
        echo "PLEASE USE A VALID VALUE FOR THE CIRD. ( Example: 10.0.0.0/16 - 172.31.0.0/16 )"
        cirdVpc
        fi
}

function createVpc () {
        echo "
        ##################
        ## VPC CREATION ##
        ##################
        "
        #Creamos la VPC y Anotamos el ID= vpc-0592e214c51b14e50 de la salida para colocar el tag Name 
        VPC_PRINCIPAL_ID=$(aws ec2 create-vpc --cidr-block $CIRDVPC --region ${REGION} | jq -r '.Vpc.VpcId')
        sleep 2
        #Agregamos tags a la VPC / Anotamos el ID= 
        aws ec2 create-tags --resources ${VPC_PRINCIPAL_ID} --tags Key=Name,Value=${PROJECT} --region ${REGION}
        echo "$PROJECT ID = ${VPC_PRINCIPAL_ID} is done"
            
        createPublicSubnet
}

function createPublicSubnet () {
        echo "
        ############################
        ##PUBLIC SUBNETS CREATION ##
        ############################
        "
        #Definimos el CIRD para las subredes
        OCT1=$(echo $CIRDVPC | cut -d"/" -f1 | cut -d"." -f1)
        OCT2=$(echo $CIRDVPC | cut -d"/" -f1 | cut -d"." -f2)
        OCT4=$(echo $CIRDVPC | cut -d"/" -f1 | cut -d"." -f4)
        CIRDini=$OCT1.$OCT2
        CIRDfin=$OCT4/24
        #Creamos la primera subred pública en la AZA / Anotamos el ID= subnet-08847660e83c390df 
        PUBLIC_SUBNET_AZA=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.1.$CIRDfin --availability-zone ${REGION}a --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${PUBLIC_SUBNET_AZA} --tags Key=Name,Value=1-${PUBLIC_SUBNET_NAME}-AZA --region ${REGION}
        #Creamos la segunda subred pública en la AZB / Anotamos el ID= subnet-0886386e60cd805c6
        PUBLIC_SUBNET_AZB=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.2.$CIRDfin --availability-zone ${REGION}b --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${PUBLIC_SUBNET_AZB} --tags Key=Name,Value=2-${PUBLIC_SUBNET_NAME}-AZB --region ${REGION}
        #Creamos la segunda subred pública en la AZB / Anotamos el ID= subnet-0886386e60cd805c6
        PUBLIC_SUBNET_AZC=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.3.$CIRDfin --availability-zone ${REGION}c --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${PUBLIC_SUBNET_AZC} --tags Key=Name,Value=3-${PUBLIC_SUBNET_NAME}-AZC --region ${REGION}
        echo "Public Subnet AZA = ${PUBLIC_SUBNET_AZA} is done"
        echo "Public Subnet AZB = ${PUBLIC_SUBNET_AZB} is done"
        echo "Public Subnet AZC = ${PUBLIC_SUBNET_AZC} is done"

        createPrivateSubnet
}

function createPrivateSubnet () {
        echo "
        ###############################
        ## PRIVATES SUBNETS CREATION ##
        ###############################
        "
        #Creamos la primera subred privada en la AZA / Anotamos el ID= subnet-064b77270d5829c24
        PRIVATE_SUBNET_AZA=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.4.$CIRDfin --availability-zone ${REGION}a --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${PRIVATE_SUBNET_AZA} --tags Key=Name,Value=1-${PRIVATE_SUBNET_NAME}-AZA --region ${REGION}
        #Creamos la segunda subred privada en la AZB / Anotamos el ID= subnet-064b77270d5829c24
        PRIVATE_SUBNET_AZB=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.5.$CIRDfin --availability-zone ${REGION}b --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${PRIVATE_SUBNET_AZB} --tags Key=Name,Value=2-${PRIVATE_SUBNET_NAME}-AZB --region ${REGION}
        #Creamos la tercera subred privada en la AZC / Anotamos el ID= subnet-064b77270d5829c24
        PRIVATE_SUBNET_AZC=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.6.$CIRDfin --availability-zone ${REGION}c --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${PRIVATE_SUBNET_AZC} --tags Key=Name,Value=3-${PRIVATE_SUBNET_NAME}-AZC --region ${REGION}
        echo "Private Subnet AZA = ${PRIVATE_SUBNET_AZA} is done"
        echo "Private Subnet AZB = ${PRIVATE_SUBNET_AZB} is done"
        echo "Private Subnet AZC = ${PRIVATE_SUBNET_AZC} is done"

        createDatabaseSubnet
}

function createDatabaseSubnet () {
        echo "
        ###########################
        ## BBDD SUBNETS CREATION ##
        ###########################
        "
        #Creamos la primera subred privada en la AZA / Anotamos el ID= subnet-064b77270d5829c24
        BBDD_SUBNET_AZA=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.7.$CIRDfin --availability-zone ${REGION}a --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${BBDD_SUBNET_AZA} --tags Key=Name,Value=1-${BBDD_SUBNET_NAME}-AZA --region ${REGION}
        #Creamos la segunda subred privada en la AZB / Anotamos el ID= subnet-064b77270d5829c24
        BBDD_SUBNET_AZB=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.8.$CIRDfin --availability-zone ${REGION}b --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${BBDD_SUBNET_AZB} --tags Key=Name,Value=2-${BBDD_SUBNET_NAME}-AZB --region ${REGION}
        #Creamos la tercera subred privada en la AZC / Anotamos el ID= subnet-064b77270d5829c24
        BBDD_SUBNET_AZC=$(aws ec2 create-subnet --vpc-id ${VPC_PRINCIPAL_ID} --cidr-block $CIRDini.9.$CIRDfin --availability-zone ${REGION}c --region ${REGION} | jq -r '.Subnet.SubnetId')
        aws ec2 create-tags --resources ${BBDD_SUBNET_AZC} --tags Key=Name,Value=3-${BBDD_SUBNET_NAME}-AZC --region ${REGION}
        echo "BBDD Subnet AZA = ${BBDD_SUBNET_AZA} is done"
        echo "BBDD Subnet AZB = ${BBDD_SUBNET_AZB} is done"
        echo "BBDD Subnet AZC = ${BBDD_SUBNET_AZC} is done"

        createIg
}

function createIg () {
        echo "
        ################
        ## CREATE IGW ##
        ################
        "
        #Creamos el internetgateway para la VPC / Anotamos el ID= igw-0b7a14cd0e05dfe6a
        IGW_VPC_PRINCIPAL=$(aws ec2 create-internet-gateway  --region ${REGION} | jq -r '.InternetGateway.InternetGatewayId')
        aws ec2 create-tags --resources ${IGW_VPC_PRINCIPAL} --tags Key=Name,Value=IGW-${PROJECT} --region ${REGION}
        #Attach el internetgateway a la VPC
        aws ec2 attach-internet-gateway --internet-gateway-id ${IGW_VPC_PRINCIPAL} --vpc-id ${VPC_PRINCIPAL_ID} --region ${REGION}
        echo "Internet Gateway = ${IGW_VPC_PRINCIPAL} is done"

        createNatGateway
}

function createNatGateway () {
        echo "
        ########################
        ## CREATE NAT GATEWAY ##
        #######################
        "
        #Generamos las EIP
        EIP_NAT_AZA=$(aws ec2 allocate-address --domain vpc --region ${REGION} | jq -r '.AllocationId')
        aws ec2 create-tags --resources ${EIP_NAT_AZA} --tags Key=Name,Value=EIP_NAT_AZA --region ${REGION}
        EIP_NAT_AZB=$(aws ec2 allocate-address --domain vpc --region ${REGION} | jq -r '.AllocationId')
        aws ec2 create-tags --resources ${EIP_NAT_AZB} --tags Key=Name,Value=EIP_NAT_AZB --region ${REGION}

        NAT_AZA=$(aws ec2 create-nat-gateway --subnet-id ${PUBLIC_SUBNET_AZA} --allocation-id ${EIP_NAT_AZA} --region ${REGION} | jq -r '.NatGateway.NatGatewayId')
        aws ec2 create-tags --resources ${NAT_AZA} --tags Key=Name,Value=NAT_Gateway_AZA --region ${REGION}

        NAT_AZB=$(aws ec2 create-nat-gateway --subnet-id ${PUBLIC_SUBNET_AZB} --allocation-id ${EIP_NAT_AZB} --region ${REGION} | jq -r '.NatGateway.NatGatewayId')
        aws ec2 create-tags --resources ${NAT_AZB} --tags Key=Name,Value=NAT_Gateway_AZB --region ${REGION}

        echo "NAT Gateway AZA = ${NAT_AZA} is done"
        echo "NAT Gateway AZB = ${NAT_AZB} is done"

        #Validando status del NAT
        NAT1_STATUS=$(aws ec2 describe-nat-gateways --region ${REGION} | jq -r '.NatGateways[0].State')
        NAT2_STATUS=$(aws ec2 describe-nat-gateways --region ${REGION} | jq -r '.NatGateways[1].State')
        while [ $NAT1_STATUS != "available" ] ||  [ $NAT2_STATUS != "available" ];
        do
                NAT1_STATUS=$(aws ec2 describe-nat-gateways --region ${REGION} | jq -r '.NatGateways[0].State')
                NAT2_STATUS=$(aws ec2 describe-nat-gateways --region ${REGION} | jq -r '.NatGateways[1].State')
                echo "Wait for NAT to be available"
                sleep 10
        done
        echo "The NAT Gateway AZA is Availables"
        echo "The NAT Gateway AZB is Availables"

        createRouteTables
}

function createRouteTables () {
        echo "
        #########################
        ## CREATE ROUTE TABLES ##
        #########################
        "
        #Al crear la VPC se crea por defecto una Route table / colocamos tags identificandola por el ID de la VPC
        RT_PUBLIC_VPC_PRINCIPAL=$(aws ec2 describe-route-tables --region ${REGION} | jq -r '.RouteTables[].RouteTableId' | tail -1)
        aws ec2 create-tags --resources ${RT_PUBLIC_VPC_PRINCIPAL} --tags Key=Name,Value=RT-Public --region ${REGION}
        echo "Public Router table = ${RT_PUBLIC_VPC_PRINCIPAL} is done"
        #Creamos la tabla de rutas privadas para la AZA / Anotamos el ID= rtb-017f20e40c4ff5fb5
        RT_PRIVATE_VPC_PRINCIPAL_AZA=$(aws ec2 create-route-table --vpc-id ${VPC_PRINCIPAL_ID} --region ${REGION} | jq -r '.RouteTable.RouteTableId')
        aws ec2 create-tags --resources ${RT_PRIVATE_VPC_PRINCIPAL_AZA} --tags Key=Name,Value=RT-Private_AZB --region ${REGION}
        echo "Private Router table AZA = ${RT_PRIVATE_VPC_PRINCIPAL_AZA} is done"

        #Creamos la tabla de rutas privadas para AZB / Anotamos el ID= rtb-017f20e40c4ff5fb5
        RT_PRIVATE_VPC_PRINCIPAL_AZB=$(aws ec2 create-route-table --vpc-id ${VPC_PRINCIPAL_ID} --region ${REGION} | jq -r '.RouteTable.RouteTableId')
        aws ec2 create-tags --resources ${RT_PRIVATE_VPC_PRINCIPAL_AZB} --tags Key=Name,Value=RT-Private_AZA --region ${REGION}
        echo "Private Router table AZB = ${RT_PRIVATE_VPC_PRINCIPAL_AZB} is done"

        #Agregamos rutas para la nueva route table public
        aws ec2 create-route --route-table-id ${RT_PUBLIC_VPC_PRINCIPAL} --destination-cidr-block 0.0.0.0/0 --gateway-id ${IGW_VPC_PRINCIPAL} --region ${REGION}

        #Agregamos rutas para la nueva route table private AZA
        aws ec2 create-route --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZA} --destination-cidr-block 0.0.0.0/0 --nat-gateway-id ${NAT_AZA} --region ${REGION}

        #Agregamos rutas para la nueva route table private AZB
        aws ec2 create-route --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZB} --destination-cidr-block 0.0.0.0/0 --nat-gateway-id ${NAT_AZB} --region ${REGION}

        #Asociamos las subredes publicas a sus respectivas RT
        aws ec2 associate-route-table --route-table-id ${RT_PUBLIC_VPC_PRINCIPAL} --subnet-id ${PUBLIC_SUBNET_AZA} --region ${REGION}
        aws ec2 associate-route-table --route-table-id ${RT_PUBLIC_VPC_PRINCIPAL} --subnet-id ${PUBLIC_SUBNET_AZB} --region ${REGION}
        aws ec2 associate-route-table --route-table-id ${RT_PUBLIC_VPC_PRINCIPAL} --subnet-id ${PUBLIC_SUBNET_AZC} --region ${REGION}

        #Asociamos las subredes privadas a sus respectivas RT
        aws ec2 associate-route-table --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZA} --subnet-id  ${PRIVATE_SUBNET_AZA} --region ${REGION}
        aws ec2 associate-route-table --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZA} --subnet-id  ${BBDD_SUBNET_AZA} --region ${REGION}
        #--
        aws ec2 associate-route-table --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZB} --subnet-id  ${PRIVATE_SUBNET_AZB} --region ${REGION}
        aws ec2 associate-route-table --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZB} --subnet-id  ${BBDD_SUBNET_AZB} --region ${REGION} 

        aws ec2 associate-route-table --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZB} --subnet-id  ${PRIVATE_SUBNET_AZC} --region ${REGION}
        aws ec2 associate-route-table --route-table-id ${RT_PRIVATE_VPC_PRINCIPAL_AZB} --subnet-id  ${BBDD_SUBNET_AZC} --region ${REGION}
        
        varVpcExport
}
function  varVpcExport () {
        touch variables.txt
        conf=./variables.txt
cat > $conf << EOF
REGION=${REGION}
PROJECT=${PROJECT}
VPC_ID=${VPC_PRINCIPAL_ID}
CIRDVPC=${CIRDVPC}
PUBLIC_SUBNET_AZA=${PUBLIC_SUBNET_AZA}
PUBLIC_SUBNET_AZB=${PUBLIC_SUBNET_AZB}
PUBLIC_SUBNET_AZC=${PUBLIC_SUBNET_AZC}
PRIVATE_SUBNET_AZA=${PRIVATE_SUBNET_AZA}
PRIVATE_SUBNET_AZB=${PRIVATE_SUBNET_AZB}
PRIVATE_SUBNET_AZC=${PRIVATE_SUBNET_AZC}
BBDD_SUBNET_AZA=${BBDD_SUBNET_AZA}
BBDD_SUBNET_AZB=${BBDD_SUBNET_AZB}
BBDD_SUBNET_AZC=${BBDD_SUBNET_AZC}
EOF
}
header
echo "The deployment was successful"