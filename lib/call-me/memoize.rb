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
	refine_method :method_added, :prefix => '__memoize' do |name|
		next if name == 'temporary method for refining'

		memoize(name) if @__to_memoize__

		__memoize_method_added(name)
	end

	refine_method :singleton_method_added, :prefix => '__memoize' do |name|
		next if name == 'temporary method for refining'

		singleton_memoize(name) if @__to_singleton_memoize__

		__memoize_singleton_method_added(name)
	end
end

class Object
	def is_memoized? (name)
		respond_to? "__memoize_#{name}"
	end

	# Memoize the method +name+.
	def memoize (name = nil)
		return if @__to_memoize__ = !name

		to_call = "__memoize_#{name}"

		begin; if instance_method(name).arity == 0
			refine_method name, :prefix => '__memoize' do
				(memoize_cache[name][nil] ||= [__send__(to_call)])[0]
			end

			return
		end; rescue; end

		refine_method name, :prefix => '__memoize' do |*args|
			if tmp = memoize_cache[name][args]
				tmp
			else
				memoize_cache[name][__memoize_try_to_clone__(args)] = [__send__(*([to_call] + args))]
			end[0]
		end

		nil
	end

	# Memoize the singleton method +name+.
	def singleton_memoize (name = nil)
		return if @__to_singleton_memoize__ = !name

		to_call = "__memoize_#{name}"

		begin; if method(name).arity == 0
			refine_singleton_method name, :prefix => '__memoize' do
				(memoize_cache[name][nil] ||= [__send__(to_call)])[0]
			end

			return
		end; rescue; end

		refine_singleton_method name, :prefix => '__memoize' do |*args, &block|
			if tmp = memoize_cache[name][args]
				tmp
			else
				memoize_cache[name][__memoize_try_to_clone__(args)] = [__send__(*([to_call] + args))]
			end[0]
		end

		nil
	end

	# Clear the memoize cache completely or only for the method +name+
	def memoize_clear (name = nil)
		if name
			memoize_cache.delete(name.to_sym)
		else
			memoize_cache.clear
		end
	end

	# Get the memoization cache
	def memoize_cache
		@__memoize_cache__ ||= Hash.new { |h, k| h[k] = {} }
	end

	private

	def __memoize_try_to_clone__ (value) # :nodoc:
		begin
			Marshal.load(Marshal.dump(value))
		rescue Exception
			value
		end
	end
end
