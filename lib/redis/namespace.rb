require 'redis'

class Redis
  class Namespace
    # Generated from http://code.google.com/p/redis/wiki/CommandReference
    # using the following jQuery:
    #
    # $('.vt li a').map(function(){ return $(this).text().toLowerCase() }).sort()
    COMMANDS = [
      "auth",
      "bgsave",
      "dbsize",
      "decr",
      "decrby",
      "del",
      "exists",
      "expire",
      "flushall",
      "flushdb",
      "get",
      "getset",
      "incr",
      "incrby",
      "info",
      "keys",
      "lastsave",
      "lindex",
      "llen",
      "lpop",
      "lpush",
      "lrange",
      "lrem",
      "lset",
      "ltrim",
      "mget",
      "monitor",
      "move",
      "quit",
      "randomkey",
      "rename",
      "renamenx",
      "rpop",
      "rpush",
      "sadd",
      "save",
      "scard",
      "sdiff",
      "sdiffstore",
      "select",
      "set",
      "setnx",
      "shutdown",
      "sinter",
      "sinterstore",
      "sismember",
      "slaveof",
      "smembers",
      "smove",
      "sort",
      "srem",
      "sunion",
      "sunionstore",
      "ttl",
      "type",
      "[]",
      "[]="
    ]

    def initialize(namespace, options = {})
      @namespace = namespace
      @redis = options[:redis]
    end

    # Ruby defines a now deprecated type method so we need to override it here
    # since it will never hit method_missing
    def type(key)
      call_command(['type', key])
    end

    def mapped_mget(*keys)
      result = {}
      mget(*keys).each do |value|
        key = keys.shift
        result.merge!(key => value) unless value.nil?
      end
      result
    end

    def mget(*keys)
      keys = keys.map { |key| "#{@namespace}:#{key}"} if @namespace
      call_command([:mget] + keys)
    end

    def method_missing(command, *args, &block)
      if COMMANDS.include?(command.to_s) && args[0]
        args[0] = "#{@namespace}:#{args[0]}"
      end

      @redis.send(command, *args, &block)
    end
  end
end
