# Contracts, Services & Endpoints

## Intro

Based on SOA and a design by contract pattern (https://en.wikipedia.org/wiki/Design_by_contract) Nomos employs service contracts to describe functionality we commit to. Services implement contracts as class interfaces to ensure compliance. Endpoints are how those services are exposed outside of the specific application's runtime domain.

## Contracts

Contracts in Nomos provide a mechanism for us to make functionality discoverable, versioned and portable. Decoupling the actual service implementations from Endpoints enable this functionality to be portable across different types of consumers, be it native php function calls, http web methods, local machine bash commands, etc.

Contracts are the piece that describe the functionality and represent the commitment we have made to support it. Contracts (and Endpoints for that matter) are post-fixed with a version number that allow us to evolve our service implementation and overall functionality without having to break or abandon legacy or hard to update clients. More about versioning below.

Contracts also enable the functionality to be discoverable in that the Endpoints or other code can iterate programmatically, functionality that we have in our system in order to make decisions or express features. One such feature is how our permission system works on contracts. Defining permissions in doc comments dictates which permissions are required to access said methods.

### Permissions

    /**
     * @permission administrator|user
     * @param $userid
     * @param $password
     */
    public function UpdatePassword($userid, $password);

The above example shows either an administrator permission or user permission can call this method. This will protect this method from being accessed anonymously or by any other principle which does not have our desired permissions without us having to do any extra work. Additionally within our service method we can adjust our behavior of how we handle the request depending on the context. In this example, UpdatePassword can work to change anyone's password if you have administrator permission but you can only update your own password if you only have the user permission.

Multiple @permission lines are combined as AND, single line @permission arguments separated by the pipe character are OR. E.g.

    @permission administrator|user
    @permission full-profile

The above example would mean: you need to have administrator OR user but in either case you also need full-profile:

    (administrator || user) && full-profile

### Versioning

You'll notice both contracts and endpoint class names have post-fixed numbers (e.g. UserService1) this is a versioning scheme on our contracts. This version allows us to update our functionality internally but still fulfill the original contract if we have legacy clients that depend on a certain contract version but are unable to update in a timely manner or at all.

E.g. embedded device that controls access to a tool users our UserService1.GetUsername method to display a user's name but we want to refactor that method or change the parameters, or even get rid of it.

We can do this by making a new method on the contract and appending a number (i.e. GetUsername1) or we create a new contract UserService2.

We now update the service implementation class to implement both UserService1 and UserService2 contracts, we can change the implementations of the UserService1 methods to point to UserService2 methods but we still honor the contract, got to update our code but still supported our legacy client.

## Endpoints

In most cases with Nomos we expose our services via JSON Endpoints. Hence, most of our service endpoints extend JsonEndpoint.

Namespacing and context registration is important in Nomos to describe where our endpoints actually point. Nomos employs an HTTP server which registers a module to handle our JSON endpoints. This module registers its self on a namespace to ensure compartmentalization and avoid conflicts with an other endpoint type. Strictly speaking, our JSON Endpoint handler is registered on ~/web/ and our Endpoint class names are registered as EndpointClassName.svc

App entry point /services/ JSON endpoint module base path ~/web/ : /services/web/EndpointClassName.svc

Now that we have an Endpoint registration, service methods that the contract implement can be called:

/services/web/EndpointClassName.svc/Method?arg1=value

Our JSON Endpoints support both GET and POST and translating natural HTTP key=value parameters. Alternatively you can provide parameters as JSON formatted data to a json parameter. E.g. /services/web/EndpointClassName.svc/Method?json={"all":"values"}


//todo wip @laftho