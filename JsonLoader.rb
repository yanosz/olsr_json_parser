#!/usr/bin/ruby

require 'json'
require './models.rb'
LOG = Logger.new (STDOUT)

class JsonLoader
  FILENAMES = {
    "gizmo-01" => "gizmo-01-status.json",
    "gizmo-02" => "gizmo-02-status.json",
    "gizmo-03" => "gizmo-03-status.json",
    "gizmo-04" => "gizmo-04-status.json",
    "gizmo-05" => "gizmo-05-status.json",
    "gizmo-06" => "gizmo-06-status.json"
  }
  
  def load_directory(root_dir)
    Dir.glob("#{root_dir}/146*") do |batch|      
      request = File.basename(batch)

      FILENAMES.each_pair do |node, file| 
        path = "#{batch}/#{file}"
 #       LOG.debug "Importing #{path}"
        load_file path,node,request
      end
    end
  end

  def load_file(path,node,request)
    json = File.read(path)
    begin 
      data = JSON.parse(json)
      save_metadata(data,node,request)
      save_neighbors(data,node,request)
      save_links(data,node,request)
      save_routes(data,node,request)
    rescue JSON::ParserError => e
     error = Error.new 
     error.filename = path
     error.error = "Error parsing #{path}:  #{e}"
     error.save
    end
  end

  def save_routes(json,node,request)
    json["routes"].each do |route|
      r = Route.new
      r.node = node
      r.request = request
      r.destination = route["destination"]
      r.genmask = route["genmask"]
      r.gateway = route["gateway"]
      r.metric = route["metric"]
      r.rtpmetriccost = route["rtpMetricCost"]
      r.networkinterface = route["networkInterface"]
      r.save
    end
  end

  def save_links(json,node,request)
    json["links"].each do |link|
      l = Link.new
      l.node = node
      l.request = request
      l.localip = link["localIP"]
      l.remoteip = link["remoteIP"]
      l.validitytime = link["validityTime"]
      l.linkquality = link["linkQuality"]
      l.neighborlinkquality = link["neighborLinkQuality"]
      l.linkcost = link["linkCost"]
      l.save!
    end
  end

  def save_neighbors(json,node,request)
    json["neighbors"].each do |neighbor|
      n = Neighbor.new
      n.node = node
      n.request = request
      n.ipaddress = neighbor["ipAddress"]
      n.symmetric = neighbor["symmetric"]
      n.multipointrelay = neighbor["multiPointRelay"]
      n.multipointrelayselector = neighbor["multiPointRelaySelector"]
      n.willingness = neighbor["willingness"]
      n.twohopneighborcount = neighbor["twoHopNeighborCount"]
      n.save!
    end
  end

  def save_metadata(json,node,request)
    j = JsonMetadata.new
    j.node = node
    j.request = request
    j.systemtime = json["systemTime"]
    j.timesincestartup = json["timeSinceStartup"]
    j.save
  end

end

JsonLoader.new.load_directory '../raw_data'
