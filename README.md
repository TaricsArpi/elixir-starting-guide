We've already covered why Elixir and Phoenix are worth a try, but making the switch can be tricky. Elixir is a world apart from the JavaScript ecosystem, but we're here to offer you a familiar reference point as you dive in. To do this, we're crafting a series of articles that explain Elixir using JavaScript lingo. So, without further ado, let's kick things off by diving into what Elixir is, how to get it up and running, and to wrap things up, we'll show you how to create a "Hello, world!" application in a few different ways.

# What is Elixir?

Elixir is a dynamic, functional programming language. This should not be so strange, as JavaScript is also dynamic and provides some functional aspects, like `Array.prototype.map`/`filter`/`reduce` and friends. In recent years, JavaScript has also moved away from APIs that mutate data and started to embrace a more immutable paradigm, where methods return new updated values, instead of overwriting the object they were called on.

Elixir runs on the Erlang Virtual Machine (called BEAM), which is somewhat analogous to how V8 works for Node.js. You might know that Erlang is also a language in its own right, so what's the deal? Just as with V8, which supports different languages like TypeScript, ClojureScript, Scala.js, and CoffeeScript (RIP), BEAM has its unique ecosystem. However, while TypeScript and others compile to JavaScript, both Elixir and Erlang compile into BEAM bytecode. This setup is more similar to JVM languages like Java, Scala, Clojure, and Kotlin. If you're not familar with these, think of it as when JavaScript is parsed, it would be compiled into wasm instrucutions. In that case, JS would also be a wasm target like all other languages that have a wasm compiler: C++, Rust, Go etc.

However, the BEAM is not like any other VM. It would be beyond the scope of this post to delve into the fault tolerance provided by this technology, but as you write your code in Elixir, you'll notice that when something breaks, the effect is similar to that in JavaScript: only the part of the application where you had the error breaks, and the rest continues to function. But you'll probably find it much more difficult to crash an entire Elixir application than a Node.js backend. The reason behind this is Elixir's concurrency model, which is based on lightweight BEAM processes functioning as actors, in line with the [actor model](https://en.wikipedia.org/wiki/Actor_model). This makes reasoning about your code in Elixir a lot easier than in Node.js. Most tasks run in separate processes, so many operations can be synchronous. It's akin to using worker threads for every request your server handles, but much more lightweight and easier to manage. However, unlike worker threads, or threads in general, BEAM processes don't share memory, making it very difficult – if not virtually impossible – to encounter race conditions. That's one of the reasons why Elixir has gained popularity, particularly for developing robust and scalable web applications using the Phoenix framework.

While we're on the topic, let's touch on OTP. When installing Elixir, you'll also need to install Erlang, ensuring that their versions are compatible. Most of the time, however, the Erlang version will be referred to as the Erlang/OTP version or simply the OTP version. OTP comprises a set of libraries usable in both Erlang and Elixir. But it's not your typical lodash or express. It includes abstractions over BEAM processes, an Application concept, a method for communication between BEAM nodes, a Redis-like distributed term storage called [ETS](https://hexdocs.pm/elixir/main/ets.html), and [Mnesia](https://en.wikipedia.org/wiki/Mnesia), which is AN ACTUAL BUILT-IN DATABASE similar to MongoDB.

And let's pause for a moment to talk about communicating between BEAM nodes. Essentially, you can start Elixir apps on different machines, link them together, and then call functions from one node on another. There's no need for HTTP, messaging queues, or REST APIs. You simply call the function on one machine and receive the result from another. 

![Exploding brain](https://media1.giphy.com/media/26ufdipQqU2lhNA4g/giphy.gif?cid=ecf05e47bjawp70bfkc13g99iylbvfa28f5sq5cwl51v3okq&ep=v1_gifs_search&rid=giphy.gif&ct=g)

This is why it was so straightforward for Chris McCord to implement Fly.io's [FLAME](https://fly.io/blog/rethinking-serverless-with-flame/) serverless/lambda-like service for Elixir. FLAME's spiritual predecessor, [Modal](https://modal.com/) was developed for machine learning in Python, but it took an entire company and years to complete.

# How to install Elixir?

Just like with Node.js, you there are multiple ways to install Elixir. You can use your OS's package manager, run it with Docker, or download prebuilt binaries. However, you'll probably want to be able to control which version of Elixir you're using, so the best is to use a version manager. In our experience, it's also the easiest way.

## What's up with Elixir and Erlang compatibility?
When working with Elixir and Erlang, it's generally recommended to use compatible versions of both to avoid potential issues. The compatibility between Elixir and Erlang versions is crucial, as certain features or enhancements in Elixir may rely on specific Erlang/OTP releases, given their shared execution environment on the BEAM virtual machine. 
If you install incompatible versions, you might encounter issues such as:
- **Functionality Breakage**: Certain Elixir features may depend on Erlang/OTP features introduced in specific versions.
- **Performance Issues**: Newer versions of Erlang/OTP often come with performance improvements and bug fixes.
- **Potential Bugs**: Running Elixir on an incompatible Erlang version may lead to unexpected behavior, errors, or even crashes due to mismatches in the underlying runtime.

Checking the compatibility matrix in the [Elixir documentation](https://hexdocs.pm/elixir/1.12/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp) is a recommended approach. For optimal performance, use the Erlang version against which Elixir was compiled.

## Which version manager to use?

You might be tempted to go the Node.js way and look for a language specific version manager. They exist, namely [`kiex`](https://github.com/taylor/kiex) for Elixir and [`kerl`](https://github.com/yrashk/kerl) for Erlnag. However, we found the easiest is to use `asdf` instead, which is a multi-language version manager that supports multiple languages, including Elixir, Erlang, Node.js, Ruby, Python, and more. The added benefit of `asdf` comes out when you work on projects that involve multiple languages - in contrast, `nvm`, `kiex`, and `kerl` are specifically designed for their respective languages. 

To install `asdf` follow the instructions [here](https://asdf-vm.com/guide/getting-started.html#_3-install-asdf)

Aftrer you install `asdf`, however, you're not ready to start downloading runtimes yet. Actually, `asdf` is more like a backend for multiple version managers that are called plugins in `asdf` parlance. In the following, we'll look at how to add language plugins, install Erlang and Elixir, then set the versions to be used.

## Install Erlang and Elixir with `asdf`

Let's add Erlang first


```sh
$ asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
```

Then Elixir.

```sh
$ asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
```

Now we need to check the available Elixir versions first with `asdf list-all elixir`.

![Elixir versions](/images/installation/elixir-list-all.png)

Notice the `otp-XX` suffix at the end of version names. That's how we know against which Erlang version was the specific runtime compiled. Pick one you like, in our case, let's go with the current latest, OTP 26 in our case. 

Let's take a look at the available Erlang versions too.

![erlang versions](/images/installation/erlang-list-all.png)

At the time of writing, `26.2.1` is the latest, so we're going to install that.

```sh
$ asdf install erlang 26.2.1
```

And now, we're ready to install the latest Elixir version.

```sh
$ asdf install elixir 1.16.0-otp-26
```

To verify the install, we just need to start the Erlang REPL

``` sh
$ erl
```

Let's verify this install too.

``` sh
$ elixir -v
```
## Local and Global versions

Unlike `nvm`, `asdf` makes it seamless to use project local versions. With `nvm` you create a `.nvmrc` file and whenever you enter the project root directory you need to run `nvm use` to switch to the proper Node version or alias the default version as... well... `default`. On the other hand, with `asdf` you can set project **local** and system-wide **global** versions.

1. Global

```sh
$ asdf global erlang 26.2.1

$ asdf global elixir 1.16.0-otp-26
```

2. Local

In you projects root directory run the following command.

```sh
$ asdf local elixir 1.16.0-otp-26

$ asdf local erlang 26.2.1
```

This will create a `.tool-versions` file with the defined versions.

![.tool-versions](/images/installation/tool-versions.png)

Now every time you `cd` into that directory, `asdf` will automatically set the runtime versions to the one you need for the given project. 

You can verify the version in use by starting the Erlang REPL and running `elixir -v`

```
$ erl
Erlang/OTP 26 [erts-14.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]

Eshell V14.2.1 (press Ctrl+G to abort, type help(). for help)
1> halt().

$ elixir -v
Erlang/OTP 26 [erts-14.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]

Elixir 1.16.0 (compiled with Erlang/OTP 26)
```

Notice the `.` at the end of the `halt().` call in the Erlang REPL. You can exit with a double Ctrl+C too, but it's just more elegant.

# Hello World in Elixir
First launch a the IEx (Interactive Elixir) REPL in the terminal:

![Launch IEx](/images/hello_world/iex.png)

```
$ iex
iex(1)> IO.puts "Hello, world!"
Hello, world!
:ok
iex(2)>
```

When calling a function, wrapping the arguments in `()` is optional. This can be very convenient when you're just playing around in the REPL. 

So far so good. But when you started out with Node, you probably wrote and `index.js` file with `console.log` in it and ran it with `node`. For me it was definitely needed to feel like a big boy.

Let's do so by creating a file called `hello_world.exs`.

![Elixir hello world file](/images/hello_world/elixir-hello-world-file.png)

Once it's saved, we're ready to execute it.

```sh
$ elixir hello_world.exs
```

![Elixir hello world execution](/images/hello_world/elixir-hello-world-file-execute.png)

Wait, what did just happen? I told you that Elixir is a compiled language, yet we ran our `Hello, world!` just like you do with a script. Well, you don't necessarily need to save the binaries to a file do you? When you run some Elixir code with the `elixir` command, it get's compiled, but only held in memory, which can be useful for setup scripts, `mix` tasks and the likes. By convention, `.exs` files are used this sript-like way and `ex` files are compiled and serialized into files.

All right then, how do we compile Elixir programs properly? Now that's a bit more complex, as most of the time, you will use [`release`](https://hexdocs.pm/mix/Mix.Tasks.Release.html)s. But for now let's do it the way you'd use for creating CLI programs, even though you'll most likley never do so. It's only to get a sense of some sort of fulfillment.

## Our first -- very simple -- project

Let's create or first Elixir project with the help of `mix`, which is somewhat similar to `npm`: you use it to download packages, build your projects or run them in development mode. Let us know if you'd like a post on comparing `npm` and `pacakge.json` with `mix` and `mix.exs`.

Time to get back to your terminal of choice and run:

```sh
$ mix new elixir_hello_world
```

It creates a simple project library structure like.

```text
elixir_hello_world
├── README.md
├── lib
│   └── elixir_hello_world.ex
├── mix.exs
└── test
    ├── elixir_hello_world_test.exs
    └── test_helper.exs
```

Let's open `lib/elixir_hello_world.ex` it should look something like this:

```elixir
defmodule ElixirHelloWorld do
  @moduledoc """
  Documentation for `ElixirHelloWorld`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ElixirHelloWorld.hello()
      :world

  """
  def hello do
    :world
  end
end
```

In it's current from it simply returns the atom `:world`. However, that's not useful for us now, as we don't care about the return value, just want to print something to `stdout`. Let's replace the return value with our previous `IO.puts` call.

``` elixir
def hello doc
  IO.puts("Hello, world!")
end
```

Now we can call our `hello` function using `mix` by specifying the app name, module name and function, still without prior compilation.

```text
$ mix run -e ElixirHelloWorld.hello

Compiling 1 file (.ex)
Hello, world!
```

We can also load our project in the REPL:

```text
$ iex -S mix
Erlang/OTP 26 [erts-14.2.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit:ns]

Interactive Elixir (1.16.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> ElixirHelloWorld.hello
Hello, world!
:ok
iex(2)>
```

Now let's tell `mix` that this is our main module. Time to open our `mix.exs` file. Find the part that says `def project do`, and add `escript: [main_module: ElixirHelloWorld],` the following to the list within the `do ... end` block. It should look like this:

```elixir
  def project do
    [
      app: :elixir_hello_world,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: [main_module: ElixirHelloWorld],
    ]
  end
```

We also need to rename our `hello` function.

```elixir
  def main(_arg)  do
    IO.puts("Hello, world!")
  end
```

Prepriding our argument name with an underscore tells the compiler that we don't care about it's value, in turn we don't get `unused variable` warnings.

Finally, we're ready to compile our first Elixir project!

```
$ mix escript.build
Compiling 1 file (.ex)
Generated escript elixir_hello_world with MIX_ENV=dev

$ ./elixir_hello_world
Hello, world!
```

## Where to go from here?
That's the end of our intro to Elixir. We're planning to write more posts like this, where we try to explain the language we grew to love in JavaScript terms. In the meantime, we recommend exploring the official documentation of [Elixir](https://hexdocs.pm/elixir/1.16.0/introduction.html). And we do mean it, as it is probably the best official documentation and tutorial of a language we've ever seen, so it should definitely be your starting point. If you find the docs from Google though, make sure you switch to 1.16.0, using the dropdown menu in the upper left corner, as it points to the documentation of older versions.

![Elixir docs](/images/hello_world/docs.png)
