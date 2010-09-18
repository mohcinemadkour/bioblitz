class FusionTablesClientWrapper

  @@_reserved_words = [:order]
  
  class << self
    
    def table_name(table_name)
      @table_name = table_name
    end

    def field(field_name)
      return unless field_name
      @fields = [] if @fields.nil?
      @fields.push( @@_reserved_words.include?(field_name) ? "'#{field_name}'" : field_name ) if @fields
    end

    def all(filters = '')
      return table.select(@fields.join(','), filters) if table && @fields
      []
    end

    def where(filters = '')
      all("WHERE #{filters}")
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