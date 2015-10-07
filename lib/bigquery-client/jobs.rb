# https://cloud.google.com/bigquery/docs/reference/v2/jobs

module BigQuery
  module Jobs
    def sql(query, options = {})
      query(query, options).to_a
    end

    def find_by_sql(query, options = {})
      relation = BigQuery::Relation.new
      sql(query, options).each do |hash|
        model = BigQuery::Tuple.new
        hash.each do |k,v|
          model[k] = v
        end
        relation << model
      end
      relation
    end

    def query(query, options = {})
      RunQuery.new(self, query, options).call
    end

    def jobs_query(query, options = {})
      default = { query: query, timeoutMs: 600_000 }
      access_api(
        api_method: bigquery.jobs.query,
        body_object: default.merge(options)
      )
    end

    def load(options = {})
      access_api(
        api_method: bigquery.jobs.insert,
        body_object: {
          configuration: {
            load: options
          }
        }
      )
    end

    def jobs(options = {})
      access_api(
        api_method: bigquery.jobs.list,
        parameters: options
      )
    end

    def fetch_job(id, options = {})
      access_api(
        api_method: bigquery.jobs.get,
        parameters: { jobId: id }.merge(options)
      )
    end

    def query_results(id, options = {})
      access_api(
        api_method: bigquery.jobs.get_query_results,
        parameters: { jobId: id }.merge(options)
      )
    end
  end
end
