class FusionTablesClientWrapper

  @@_reserved_words = [:order]
  
  class << self
    
    def table_name(table_name)
      @table_name = table_name
    end
    
    def field(field_name)
      return unless field_name
      @fields = [:ROWID] if @fields.nil?
      @fields.push( @@_reserved_words.include?(field_name) ? "'#{field_name}'" : field_name ) if @fields
    end

    def all(filters = '')
      return table.select(@fields.join(','), filters) if table && @fields
      []
    end

    def where(filters = '')
      all("WHERE #{filters}")
    end
    
    def create(params = nil)
      return if params.nil?
      
      fields = params.keys.map{ |key| "'#{key}'" }.join(', ')
      values = params.values.map{ |value| "'#{value}'" }.join(', ')
      sql    = "INSERT INTO #{table.id} (#{fields}) VALUES (#{values})"

      @client.sql_post(sql)
    end
    
    def update_attributes(params = nil, rowid = nil)
      return if params.nil? || rowid.nil?
      
      values = params.to_a.map { |pair| "'#{pair[0]}' = '#{pair[1]}'"}.join(', ')
      
      sql = "UPDATE #{table.id} SET #{values} WHERE ROWID='#{rowid}'"
      
      @client.sql_post(sql)
    end

    # Hack!! Since fusion tables client doesn't support aggregate querys, this 
    # method simulates the MAXIMUM aggregate function.
    def max(field)
      # All keys in results array are downcase
      field = field.to_s.downcase.to_sym

      # Discards all nil elements
      records = all.select { |x| x.present? && x[field].present? }
      # Orders by highest field
      records = records.sort { |p,n| n[field].to_i <=> p[field].to_i }
      records.first[field].to_i
    end

    def next(field)
      max(field) + 1
    end

    protected
      def client
        return @client if @client

        # Inits connection with Fusion Tables
        @client = GData::Client::FusionTables.new
        credentials = YAML::load_file("#{Rails.root}/config/credentials.yml")
        @client.clientlogin(credentials["ft_username"], credentials["ft_password"])
        @client
      end

      def client=(client)
        @client = client
      end

      def table
        @table ||= client.show_tables.select{|t| t.name == @table_name}.first if @table_name
      end

  end

end