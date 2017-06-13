require 'active_record'
require 'mysql2'

ActiveRecord::Base.establish_connection(
  adapter: 'mysql2',
  database: 'moco2016',
  encoding: 'utf8',
  username: 'root',
  host: 'localhost'
)

class JsonMetadata < ActiveRecord::Base
  
end

class Neighbor < ActiveRecord::Base

end

class Link <  ActiveRecord::Base
end

class Route < ActiveRecord::Base

end

class Error < ActiveRecord::Base

end

class Http < ActiveRecord::Base
end

class Ping < ActiveRecord::Base
end
