# unlettered-infra

Creating infrastructure manually is tedious. Managing it, even more so! So, why not use a tool to do all that work, and just tell it what you need/want, and it does all the guesswork? Why not apply some source control management, maybe some development practices to boot? Sure, and just call it "infrastructure as code" why don't you, or "IaC" for short?

Well, if we're gonna code... I want to have an environment to break things.. I mean... _test_ things. Yes. Test the changes. We'll roll with that.

## Contributing

First off, I'd like to thank you for even having the remotestestest interest in possibly contributing. And by contributing, I'm going to assume you'll probably be yoinking some code? Well, it's not like I'm not writing something new and amazing, so... good luck? It's all based on publicly available knowledge anyways..

In the off chance you still want to contribute, I'd suggest being ready to do so with following some steps, the same one's I've followed for my initial contributions.

### Virtual Python Environment

To setup this project, it is recommended to create a virtual Python environment (using the `venv` module):

    python -m venv .dev

Or, if you have a different naming convention, use that. This is the folder referenced in the `.gitignore` file, so if you use a different one, make sure to add that one to your ignored entries.

When the virtual Python environment is created, activate it by using a command similar to the following:

    source .dev/bin/activate

Your platform may have different ways to activate, and if you used a different virtual environment name, update the command accordingly, or use your integrated development environment to activate the environment automatically.

The reason for activating the virtual environment is such that when `pip` is invoked, the packages/modules installed target the virtual environment, keeping the local system packages/modules as such only needed by the system Python environment, not our project(s). A clean environment is a good environment, and one step closer to reproducibility, a good attribute for development and testing environments.

### Azure Authentication

Since the infrastructure is based in Azure, we'll need a way to authenticate with Azure, for some local testing of commands, such as `terraform validate` and `terraform plan` to see how changes in the infrastructure code will affect the Azure resources. This will require the ability to log into Azure, and the Azure CLI tools include such a command, `az login`.

However, there's not always a package available for a particular platform, but luckily, we can use `pip` to install the necessary Python modules to gain access to those tools. However, `pip` updated their dependency resolver mechanism around October 2020, so to make use of it (therefore, not see any errors or warnings in the output), we'll use a feature of `pip`:

    pip install azure-cli --use-feature=2020-resolver

With `azure-cli` installed, we are now able to log into Azure:

    az login

Note: You may run into a minor inconvenience, but it is super easy to fix. When using the `azure-cli` package installed with `pip`, executing `az login` defaults to using the browser the Python `webbrowser` module is configured to use. As it so happens, mine was set to `chromium`, by way of the `BROWSER` environment variable. I don't use Chromium as my default browser, but Python didn't know that.

Updating (overwriting) `BROWSER` in my `~/.bashrc` file fixed that, but requires logging out of the system account. Logging back in and testing the webbrowser module by opening a new window resulted in Firefox being opened (as expected), which then is used by the `az login` command. Just a minor eye twitch, but resolvable.

### Terraform

Now that we can connect with Azure, it's time to manipulate the resources therein, and for this, HashiCorp's Terraform was selected, mostly because.. that's what we use at work, and it's not 100% perfect, but it's really nice to use and I like it, so there.

However, obviously, Terraform is not installed by default, for any platform that I am aware of, so install it accordingly for your platform. Since I'm working on a Linux distribution based on Arch Linux, I can make use of Pacman to install Terraform by synchronizing the package to my system:

    sudo pacman -S terraform

We're cookin' now!

## BREAK EVERYTHING!

No, seriously, changes to your infrastructure could literally break everything dependent on your infrastructure (in your subscription(s)), so be very attentive to the output that Terraform generates.

### Initializing Terraform

Initializing Terraform informs Terraform what kind of providers are required for the infrastructure you are managing. Conveniently, there's a `providers.tf` file that kind of describes which ones are required. Also note - there is a minimum required version of Terraform specified in that file too, so make sure the version of Terraform installed meets that requirement. You can check with a simple command:

    terraform --version

If you have executed Terraform commands that have installed providers for your infrastructure, the versions of those will be included in the output as well.

### Clean Code

One of the nice things that Terraform provides is the ability to format your Terraform code, using

    terraform fmt

Some teams (such as mine at work) actually check, as part of a successful build, that the Terraform code is formatted. If it's not, it will fail the build, and you will look silly. And I have plenty of commits in work repositories that are just to fix the formatting. Will I commit unformatted code in the future? Of course. Look at my alias/nickname here ^_^

More importantly, it makes the IaC more readable, and as an extension, more maintainable. This is a desired attribute of code. So, use the tools to make your future life easier. If you remember, at least.

### Terraforming Infrastructure

So, now that we have Terraform and the ability to do the Azure things via the `azurerm` provider, we need to add one file, one tiny little file, that also happens to be an ignored file, on purpose: `terraform.auto.tfvars.json`. This file is pretty sparse, containing the following variable value(s):

```json
{
  "subscription_id": "$azureSubscriptionId"
}
```

What? You think I'm just gonna give you my subscription id? Hah, not a chance.

Well, not on purpose, anyways. So yeah, using your own Azure subscription (such as one reported when you log into Azure via `az login`), pick the id of the subscription in which you'd like to make the Azure Function App, and use it as the value of the `subscription_id` variable.

Once that's good to go, you could just jump right into planning, to see what changes to the infrastructure will occur, but I like to take a step prior: validation. It's good to know that Terraform can understand what you are trying to tell it what you want.

    terraform validate

It can spot some errors early on, and as a just-in-case kind of thing, I like to make sure I have access to the infrastructure host (in this case Azure), by already having the terminal have access to said host (in this case, using `az login`). If you don't, validation may not catch what it can, but it's not strictly required, because planning will.

If validation is successful, then by all means, let's find out what terrible things are going to happen when we tell Terraform our updated infrastructure plans, by telling Terraform to make a new plan:

    terraform plan -out tfplan

`-out tfplan` isn't strictly required, but it's nice to know that a plan can be generated, and if it's successful, then it's easy to just yeet that plan right into the invocation for Terraform to actually do the things:

    terraform apply tfplan

And... pending no surprise errors, Terraform will make the changes permanent.

### Terraform State

Help! I .. forgot to add this. Don't `terraform apply` without being ready to handle new|updated Terraform state!

So, basically, it's getting late, and I want to get some sleep. And... I'll document that when I remember (hopefully tomorrow after work).
