#!/bin/bash
#arukas command for api
# reference https://arukas.io/en/documents-en/arukas-api-reference-en/#api_reference
#app url https://app.arukas.io/
#
#function list
#/api/apps
#action:GET /app/, GET /app/{apps_id} , DELETE /apps/{app_id}
#
#/app-sets (#not support yet)
#action:POST /app-sets
#
#/containers
#action:GET /containers , POST /containers/{containers_id}/power , DELETE /containers/{containers_id}/power , PATCH /containers/{containers_id}
#
#

ARK_PANEL="https://app.arukas.io/api"
ARK_APPS=$ARK_PANEL/apps
ARK_APPSET=$ARK_PANEL/app-sets
ARK_CON=$ARK_PANEL/containers

function ark_help ()
{
cat << EOF
cli for arukas

Usage:

wget --cache=off https://raw.github.com/gzmud/arukascmd/master/arukascmd.sh && chmod +x arukascmd.sh 
. arukascmd.sh && ark_setkey ARUKAS_TOKEN ARUKAS_SECRET
EOF
}

function ark_init ()
{
#the work todo is compatible with other .netrc,with sed
cat << EOF > ~/.netrc
cli for arukas
machine app.arukas.io
    login $ARUKAS_TOKEN
    password $ARUKAS_SECRET
EOF
}

function ark_setkey ()
{
ARUKAS_TOKEN=$1
ARUKAS_SECRET$2
ark_init
}

function ark_con_ls ()
{
curl -s -n $ARK_CON \
  -H "Content-Type: application/vnd.api+json"  \
  -H "Accept: application/vnd.api+json" \
  | jq 
}

function ark_con_lsd ()
{
curl -s -n $ARK_CON \
  -H "Content-Type: application/vnd.api+json"  \
  -H "Accept: application/vnd.api+json" \
  | jq '.data []'
}

function ark_con_on ()
{
CONTAINERS_ID=$1
curl -s -n -X POST $ARK_CON/$CONTAINERS_ID/power \
  -H "Content-Type: application/vnd.api+json"  \
  -H "Accept: application/vnd.api+json" \
  | jq
}

function ark_con_off ()
{
CONTAINERS_ID=$1
curl -s -n -X DELETE $ARK_CON/$CONTAINERS_ID/power \
  -H "Content-Type: application/vnd.api+json" /*-9¡¤ \
  -H "Accept: application/vnd.api+json" \
  | jq
}

function ark_con_patch ()
{
CONTAINERS_ID=$1
curl -s -n -X PATCH DELETE $ARK_CON/$CONTAINERS_ID \
  -d \'`cat $2`\' \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  | jq
}

function ark_app_ls ()
{
curl -s -n $ARK_APPS \
  -H "Content-Type: application/vnd.api+json" \
  -H "Accept: application/vnd.api+json" \
  | jq 
}

function ark_app_lsid ()
{
APPS_ID=$1
curl -s -n $ARK_APPS/$APPS_ID \
  -H "Content-Type: application/vnd.api+json" \
  -H "Accept: application/vnd.api+json" \
  | jq 
}

function ark_app_del ()
{
APPS_ID=$1
curl -s -n -X DELETE https://app.arukas.io/api/apps/$APP_ID \ 
  -H "Content-Type: application/vnd.api+json" \
  -H "Accept: application/vnd.api+json" \
  | jq
}

function ark_app_cr()
{
curl -s -n -X POST https://app.arukas.io/api/app-sets \
  -d \'`cat $1`\' \
  -H "Content-Type: application/vnd.api+json"  \
  -H "Accept: application/vnd.api+json" \
  | jq

