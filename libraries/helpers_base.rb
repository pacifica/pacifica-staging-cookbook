# Pacifica Cookbook Modules
module PacificaCookbook
  # Pacifica Cookbook Helpers
  module PacificaHelpers
    # Helpers to call within the base action
    module Base
      def base_git_repository
        git new_resource.name do
          git_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end
      def uploader_default_config
        {
       "dataRoot": "/usr/share/man",
       "target": "/srv",
       "timeout": "1",
       "statusServer": "http://status.local/view/",
       "policyServer": "http://127.0.0.1:8181",
       "ingestServer": "http://127.0.0.1:8066",
       "timezone":  "",
       "use_celery": "True",

       "theming": {
               "theme_name": "demos",
               "site_name": "Demos",
               "site_slogan": "Data Management for Science",
               "archive_repository_name": "Pithos Archive",
               "upload_data_source_name": "a Demos Instrument",
               "uploader_page_name": "instrument data uploader"
       },
       "auth": {},
       "metadata": [
               {
                       "metaID": "logon",
                       "sourceTable": "users",
                       "destinationTable": "Transactions.submitter",
                       "value": "",
                       "displayType": "logged_on",
                       "displayTitle": "Currently Logged On",
                       "valueField": "_id",
                       "queryFields": [ "first_name", "last_name", "_id"],
                       "queryDependency": { "network_id": "logon" },
                       "diplayFormat": "%(first_name)s %(last_name)s"
               },
               {
                       "metaID": "instrumentByID",
                       "sourceTable": "instruments",
                       "destinationTable": "Transactions.instrument",
                       "displayType": "select",
                       "displayTitle": "Instrument",
                       "value": "34075",
                       "valueField": "_id",
                       "queryDependency": { "_id": "instrumentByID" },
                       "queryFields": ["_id",  "name_short", "display_name" ],
                       "diplayFormat": "%(_id)s %(name_short)s - %(display_name)s"
               },
               {
                       "sourceTable": "instruments",
                       "metaID": "instrumentDirectory",
                       "displayType": "directoryTree",
                       "directoryOrder": 1,
                       "diplayFormat": "%(name_short)s",
                       "valueField": "_id",
                       "queryDependency": { "_id": "instrumentByID" },
                       "queryFields": ["_id", "name_short"]
               },
               {
                       "sourceTable": "proposals",
                       "metaID": "ProposalByInstrument",
                       "value": "",
                       "destinationTable": "Transactions.proposal",
                       "displayTitle": "Proposal",
                       "displayType": "select",
                       "queryDependency": { "instrument_id": "instrumentByID" },
                       "valueField": "_id",
                       "queryFields": [ "_id", "title" ],
                       "diplayFormat": "%(_id)s %(title)s"
               },
               {
                       "sourceTable": "proposals",
                       "metaID": "ProposalDirectory",
                       "value": "",
                       "displayType": "directoryTree",
                       "diplayFormat": "Proposal %(_id)s",
                       "directoryOrder": 0,
                       "queryDependency": { "_id": "ProposalByInstrument" },
                       "valueField": "_id",
                       "queryFields": [ "_id"]
               },
               {
                       "sourceTable": "users",
                       "metaID": "EmslUserOfRecord",
                       "destinationTable": "TransactionKeyValue",
                       "displayTitle": "Person of Record",
                       "displayType": "select",
                       "key": "User of Record",
                       "value": "",
                       "queryDependency": { "proposal_id": "ProposalByInstrument" },
                       "valueField": "_id",
                       "queryFields": [ "first_name", "last_name", "_id"],
                       "diplayFormat": "%(first_name)s %(last_name)s"
               },
               {
                       "destinationTable": "TransactionKeyValue",
                       "metaID": "tag1",
                       "key": "Tag",
                       "value": "",
                       "displayTitle": "Tag",
                       "displayType": "enter"
               }
       ]
     }
      end
    end
  end
end
