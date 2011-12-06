#--
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'refining'

class Module
	private

	def __pattern_match (name)
		pattern_matched = (__pattern_matched__[name] ||= {})
		pattern_matched[@__to_pattern_match__ || :default] = instance_method(name)

		remove_instance_variable :@__to_pattern_match__ if @__to_pattern_match__

		define_method name do |*args, &block|
			pattern_matched.each {|signature, body|
				return body.bind(self).call(*args, &block) if (if signature.is_a?(Proc)
					if !body.parameters.empty? && signature.parameters.empty?
						names     = body.parameters.map { |p| p[1] }
						arguments = args.dup

						if names.last.nil?
							names[-1]                   = :rest
							arguments[names.length - 1] = arguments.pop(names.length)
						end

						Struct.new(*names).new(*arguments).instance_exec &signature
					else
						instance_exec *args, &signature
					end
				else
					signature == args
				end)
			}

			return pattern_matched[:default].bind(self).call(*args, &block) if pattern_matched[:default]

			raise ArgumentError, "non-exhaustive patterns"
		end
	end

	def __pattern_matched__
		@__pattern_matched__ ||= {}
	end

	def is_pattern_matched? (name)
		__pattern_matched__.has_key?(name)
	end

	def def_pattern (*sign)
		@__to_pattern_match__ = sign.first.is_a?(Proc) ? sign.first : sign
	end

	public

	def define_pattern_matched (name, default = nil, matchers)
		define_method name do |*args|
			matchers.each {|signature, body|
				return instance_exec *args, &body if (if signature.is_a?(Proc)
					signature.call(*args)
				else
					(signature.is_a?(Array) ? signature : [signature]) == args
				end)
			}

			return instance_exec *args, &default if default

			raise ArgumentError, "non-exhaustive patterns"
		end
	end

	refine_method :method_added, :prefix => '__pattern_match' do |name|
		next if name == 'temporary method for refining'

		if !@__pattern_matching__ && (@__to_pattern_match__ || is_pattern_matched?(name))
			@__pattern_matching__ = true
			__pattern_match(name)
			remove_instance_variable :@__pattern_matching__
		end

		__pattern_match_method_added(name)
	end
end
