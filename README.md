# NuSignUp

[![CI Status](http://img.shields.io/travis/Nucleus-Inc/NuSignUp.svg?style=flat)](https://travis-ci.org/Nucleus-Inc/NuSignUp)
[![Version](https://img.shields.io/cocoapods/v/NuSignUp.svg?style=flat)](http://cocoapods.org/pods/NuSignUp)
[![License](https://img.shields.io/cocoapods/l/NuSignUp.svg?style=flat)](http://cocoapods.org/pods/NuSignUp)
[![Platform](https://img.shields.io/cocoapods/p/NuSignUp.svg?style=flat)](http://cocoapods.org/pods/NuSignUp)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 10.0+

## Installation

NuSignUp is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NuSignUp"
```

### Step 1: Create a storyboard to contain your sign up flow.

### Step 2: Setting up your SignUpStackC (Optional).

This protocol exists to help user knows about his progress on sign up.
Take a look on example project for ways to use it.

Each SignUpStepVC will access your instance of  `SignUpStackC` by `self.parent` param on `viewWillAppear` only to update the current step value calling the method `updateForStep`, where on your implementation you should update for example your `UIProgressView` progress.

```swift
override open func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ...
    if let navc = self.navigationController as? SignUpStackC{
        navc.updateForStep(step: stepNumber)
    }
    ...
}
```

### Step 3: Your Sign Up Steps.

Each Sign Up Step VC must implement `SignUpStepController`.

Steps that are an instance of `SignUpStepVC` or `SignUpNameSVC` or inherits from one of them have by default its delegate value equals to `DefaultSUpSDelegate` instance. 

Probably you will need to make your changes and `DefaultSUpSDelegate` implementation of `SignUpStepDelegate` protocol will not be enough, for these cases you have two options:

- Option 1: Your Step is an instance of `SignUpStepVC` or `SignUpNameSVC`.

You can change its `delegate` param value by calling:

```swift
SignUpStack.config.baseStepDelegateType(ExampleSignUpDelegate.self)
```

Remember that doing it all your steps that are an instance of  `SignUpStepVC` will use `ExampleSignUpDelegate` instance as its delegate.

- Option 2: Your Step inherits from `SignUpStepVC` or `SignUpNameSVC`. 

Only change its delegate value.

Take a look on Example project specifically on `SignUpCodeSVC` class for a safe way to do it.


### Step 4: Going to next Sign Up Step.

`SignUpStepController` has a method called `goToNextStep` that on `SignUpStepVC` instance executes diferent transitions accordinly to  `delegate.reviewMode`.

### Do not forget to take a look on example project.

## Author

José Lucas, chagasjoselucas@gmail.com

## License

NuSignUp is available under the MIT license. See the LICENSE file for more info.
