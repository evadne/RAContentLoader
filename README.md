# RAContentLoader

Reference-counted, asynchronous content loading.


## What’s Inside

There’s an `RAContentLoader`, which does reference-counted content loading.  Resources are differentiated by key, and they conform to `NSCopying`.  Every time you need a resource, invoke `-beginLoadingObjectForKey:` on the loader, and whenever you’re done with the resource, invoke `-endLoadingObjectForKey:` to cancel pending loads, or simply mark the object as no longer needed.

The Content Loader needs a data source to work properly, and notifies the delegate about state changes in all the objects it is responsible for managing load states of.  You will have to implement `RAContentLoaderDataSource`:

	@protocol RAContentLoaderDataSource <NSObject>
	- (RAContentLoadingReference *) newLoadingReferenceForKey:(id<NSCopying>)key;
	- (id) existingResultWithVersion:(id<RAContentLoadingReferenceResultVersion> *)outVersion forKey:(id<NSCopying>)key;
	@end

in this case, `-newLoadingReferenceForKey:` returns a private (i.e. do not subclass yet, it has private parts that are not well-thought-out enough for release) object with a worker block.  You can make one by calling `-[RAContentLoadingReference initWithWorkerBlock:]`, which gives you a worker block that takes a completion block as its argument.  The block will do its work asynchronously, and call the completion block with these information when it is ready:

*	The **flag,** spcifying if the load operation finished properly.
*	The **result,** if it is successfully loaded, otherwise `nil`.
*	The **version** for the result, if load finishes successfully.
*	The **error,** if loading failed for any reason, otherwise `nil`.

You don’t have to pass a **version**, but if you do, you can discern between earlier results you gave the loader thru `-[<RAContentLoaderDataSource> existingResultWithVersion:forKey:]` and the up-to-date results you get from an asynchronous fetch operation.

If you return something other than `nil` in `-[<RAContentLoaderDataSource> existingResultWithVersion:forKey:]`, you get a prior notification carrying the prior value thru delegation immediately.  This can be helpful if you want to show a placeholder (potentially stale information) before the real thing is loaded.

You will want to implement `RAContentLoaderDelegate` to know if anything changed as well:

	@protocol RAContentLoaderDelegate <NSObject>
	- (void) contentLoader:(RAContentLoader *)loader didUpdateLoadingReference:(RAContentLoadingReference *)reference forKey:(id<NSCopying>)key;
	@end

`-[<RAContentLoaderDelegate> contentLoader:didUpdateLoadingReference:forKey:]` will be called whenever the loading reference is updated.  You get called when the load has started with a prior value, when the load fails, when the load finishes, and when the load is cancelled.


## Licensing

This project is in the public domain.  You can use it and embed it in whatever application you sell, and you can use it for evil.  However, it is appreciated if you provide attribution, by linking to the project page ([https://github.com/evadne/RAContentLoader](https://github.com/evadne/RAContentLoader)) from your application.


## Credits

*	[Evadne Wu](http://twitter.com/evadne) at Radius ([Info](http://radi.ws))
