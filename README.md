# Alarm

Students will build a simple alarm app to practice intermediate table view features, protocols, the delegate pattern, NSCoding, and UserNotifications.

Students who complete this project independently are able to:

### Part One - Intermediate TableViews, Delegate Pattern

* Implement a master-detail interface
* Implement the `UITableViewDataSource` protocol
* Implement a static `UITableView`
* Create a custom `UITableViewCell`
* Write a custom delegate protocol
* Wire up view controllers to model object controllers
* Work with `Date` and `Calendar`
* Add staged data to a model object controller

### Part Two - NSCoding, Protocol Extensions, UserNotifications

* Create model objects that conform to the `NSCoding` protocol
* Create model object controllers that use `NSKeyedArchiver` and `NSKeyedUnarchiver` for data persistence
* Schedule and cancel `UserNotification`s
* Create custom protocols
* Implement protocol functions using protocol extensions to define protcol function behavior across all conforming types

## Part One - Intermediate TableViews, Delegate Pattern

### View Hierarchy

Set up a basic List-Detail view hierarchy using a UITableViewController for a AlarmListTableViewController and a AlarmDetailTableViewController. Use the provided screenshots as a reference.

1. Add a `UITableViewController` scene that will be used to list alarms
2. Embed the scene in a `UINavigationController`
3. Add an Add system bar button item to the navigation bar
4. Add a class file `AlarmListTableViewController.swift` and assign the scene in the Storyboard
5. Add a `UITableViewController` scene that will be used to add and view alarms
* note: We will use a static table view for our Alarm Detail view, static table views should be used sparingly, but they can be useful for a table view that will never change, such as a basic form. You can make a table view static by selecting the table view, going to the Attribute Inspector, and changing the Content dropdown from Dynamic Prototypes to Static Cells.
6. Add a show segue from the Add button from the first scene to the second scene.
7. Add a show segue from the prototype cell form the first scene to the second scene.
8. Add a class file `AlarmDetailTableViewController.swift` and assign the scene in the Storyboard

### Custom Table View Cell

Build a custom table view cell to display alarms. The cell should display the alarm time, the alarm name, and have a switch that will toggle whether or not the alarm is enabled.

It is best practice to make table view cells reusable between apps. As a result, you will build a `SwitchTableViewCell` rather than an `AlarmTableViewCell` that can be reused any time you want a cell with a switch.

1. Add a new `SwitchTableViewCell.swift` as a subclass of UITableViewCell.
2. Configure the prototype cell in the Alarm List Scene in `Main.storyboard` to be an instance of `SwitchTableViewCell`
3. Design the prototype cell as shown in the screenshots: two labels, one above the other, with a switch to the right.
* note: Stack views are great. Think about using a horizontal stack view that has a vertical stack view and a switch inside of it. The vertical stack view will have two labels in it.
4. Create an IBOutlet to the custom cell file for the label named `timeLabel`.
5. Create an IBOutlet to the custom cell file for the label named `nameLabel`.
6. Create an IBOutlet to the custom cell file for the switch named `alarmSwitch`.
7. Create an IBAction for the switch named `switchValueChanged` which you will implement using a custom protocol later in these instructions.

### Static Table View

Build a static table view as the detail view for creating and editing alarms.

1. Static table views do not need to have UITableViewDataSource functions implemented. Instead, you can create outlets and actions from your prototype cells directly onto the view controller (in this case `AlarmDetailTableViewController`) as you would with other types of views.
2. If you haven't already, go to your Storyboard, select your detail table view and in the Attributes Inspector change the Style to Grouped and the Sections to 3. By default each section will have 3 cells in it. You can delete 2 of the cells in each section.
3. In section 1, drag a date picker onto the prototype cell and add proper constraints.
4. In section 2, drag a text field onto the prototype cell and add the proper constraints and placeholder text.
5. In section 3, drag a button onto the prototype cell and add the proper constraints and title. This button will be used to enable/disable existing alarms.
6. Create IBOutlets for the three items listed above and create an IBAction for the button titled `enableButtonTapped`.
7. If you haven't already, add a bar button item to the right side of the navigation bar, change the System Item to Save in the Attributes Inspector, and create an IBAction called `saveButtonTapped`.
* You will need to add a Navigation Item to the Navigation Bar before you can add the bar button item.

### Understanding Alarm Model Object

You have been given a file called `Alarm.swift` that contains your Alarm model object and another file called `DateHelper.swift`. These two files makes extensive use of Dates and Calendars. Although we did not make you create these files from scratch, we expect you to understand why they were made and how each line of code works.

1. Your Alarm class will keep track of the time each day that the alarm should fire, the name of the alarm, and whether or not the alarm is enabled. `fireTimeFromMidnight` stores a TimeInterval which represents the number of seconds from midnight. `name` is simply a `String` representing the name, and `enabled` is a `Bool` that we will set to true if the alarm is enabled and false otherwise.
2. A UUID is a Universally Unique Identifier. The `uuid` on the Alarm object will be used later to schedule and cancel local notifications
3. The `fireDate` property is a computed property that will be used in part 2 of this project to schedule notifications that will notify the user when the alarm goes off.
4. `fireTimeAsString` will be used to represent the time you want the alarm to fire. This is simply for the UI.

### Controller Basics

Create an `AlarmController` model object controller that will manage and serve `Alarm` objects to the rest of the application.

1. Create an `AlarmController.swift` file and define a new `AlarmController` class.
2. Add an `alarms` array property with an empty array as a default value.
3. Create an `addAlarm(fireTimeFromMidnight: TimeInterval, name: String)` function that creates an alarm, adds it to the `alarms` array, and returns the alarm.
4. Create an `update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String)` function that updates an existing alarm's fire time and name.
5. Create a `delete(alarm: Alarm)` function that removes the alarm from the `alarms` array
* note: There is no 'removeObject' function on arrays. You will need to find the index of the object and then remove the object at that index. Refer to documentation if you need to know how to find the index of an object.
* note: If you face a compiler error, you may need to check that the `Equatable` protocol has been properly implemented for `Alarm` objects
6. Create a static `shared` property that stores a shared instance.
* note: Review the syntax for creating shared instance properties

### Controller Staged Data Using a Mock Data Function

Add mock alarm data to the AlarmController. Using mock data can be very useful. Once there is mock data development teams can serialize work -- i.e. some can work on the views with visible data while others work on implementing the controller logic. This is a quick way to get objects visible so you can begin building the views.

There are many ways to add mock data to model object controllers. We will do so using a computed property.

1. Create a `mockAlarms:[Alarm]` computed property that holds a number of staged `Alarm` objects
* Initialize a small number of `Alarm` objects to return with varying properties
2. When you want mock data, set self.alarms to self.mockAlarms in the `AlarmController` initializer. Remove it when you no longer want mock data.
* note: If you have not added an initializer, add one.

### Wire up the Alarm List Table View and implement the property observer pattern on the `SwitchTableViewCell` class.

Fill in the table view data source functions required to display the view.

Your custom cell should follow the 'updateViews' pattern for updating the view elements with the details of a model object. To follow this pattern, the developer adds an 'updateViews' function that checks for a model object. The function updates the view with details from the model object.

1. Add a property `var alarm: Alarm?` to your `SwitchTableViewCell` class.
2. Add an `updateViews()` function that updates the labels to the time and name of the alarm, and updates the `alarmSwitch.isOn` property so that the switch reflects the proper alarm `enabled` state.
3. Add a `didSet` observer on the alarm property, and call the `updateViews()` function you just made in it.
4. On your `AlarmListTableViewController` fill in the two required `UITableViewDataSource` functions, using the `alarms` array from `AlarmController.shared`. In the `tableView(UITableView, cellForRowAt: IndexPath)` data source function you will need to cast your dequeued cell as a `SwitchTableViewCell` and set the cell's `alarm` property. Make sure you use the right alarm from the `alarms` array in `AlarmController`.
5. Implement the `UITableViewDataSource` `tableView(_:, commit:, forRowAt:)` method to enable swipe-to-delete. Be sure to call the appropriate `AlarmController` method before deleting the row.
* At this point you should be able to run your project and see your table view populated with your mock alarms. You should be able to delete rows and segue to a detail view (this detail view won't actually display an alarm yet, but the segue should still occur). Also note that you can toggle the switch, but that the `enabled` property on the model object the cell is displaying isn't actually changing.

### Custom Protocol

Write a protocol for the `SwitchTableViewCell` to delegate handling a toggle of the switch to the `AlarmListTableViewController`, adopt the protocol, and use the delegate function to mark the alarm as enabled or disabled and reload the cell.

1. Create a custom protocol named `SwitchTableViewCellDelegate` to the top of the `SwitchTableViewCell` class file
2. Define a `switchCellSwitchValueChanged(cell: SwitchTableViewCell)` function
3. Add a weak, optional delegate property on the SwitchTableViewCell
* note: `weak var delegate: SwitchTableViewCellDelegate?`
* note: If the compiler throws an error, it is likely because your protocol must be restricted to class types.
4. Update the `switchValueChanged(_:)` IBAction to check if a delegate is assigned, and if so, call the delegate protocol function
5. Adopt and conform to the protocol in the `AlarmListTableViewController` class.
6. Set the table view controller as the delegate of each cell.
7. Go to your `AlarmController` class and add a `toggleEnabled(for alarm: Alarm)` function that will switch the `enabled` property of the `alarm` in your function parameter to true if it is false, and false if it is true.
8. Go back to your `AlarmListTableViewController` class and implement the `switchCellSwitchValueChanged(cell:)` delegate function to capture the alarm, toggle the alarm's enabled property using the function you just made in `AlarmController`, and reload the table view.

### Wire up the Alarm Detail Table View

Create functions on the detail table view controller to display an existing alarm and setup the view properly.

1. Add an `alarm` property of type `Alarm?` to `AlarmDetailTableViewController`. This will hold an alarm if the view is displaying an existing alarm and will be nil if the view is being used to create a new alarm.
2. Create a private `updateViews()` function that will populate the date picker and alarm title text field with the current alarm's date and title. This function will hide the enable button if `self.alarm` is nil, otherwise it will set the enable button to say "Disable" if the alarm in `self.alarm` is enabled and "Enable" if it is disabled. You may consider changing background color and font color properties as well to make the difference between the two button states clear.
*note: You must guard against the alarm being nil, or the view controller's view not yet being loaded and properly handle these cases.
3. Create a `didSet` property observer on the `alarm` property that checks if the view has been loaded, if it has, call `updateViews()`.
4. In `viewDidLoad`, call `updateViews()` to display an alarm if there is an existing alarm. This will ensure that if the view hasn't been loaded by the time the `didSet` of the `alarm` in the previous step, the views will still be setup by the time the user is shown this view controller.

### Prepare For Segue

Fill in the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function on the `AlarmListTableViewController` to properly prepare the next view controller for the segue.

1. In the `AlarmListTableViewController`, add an if statement in the `prepare(for segue: UIStoryboardSegue, sender: Any?)` function that checks if the segue's identifier matches the identifier of the segue that goes from a cell to the detail view.
2. Get the destination view controller from the segue and cast it as an `AlarmDetailTableViewController`.
3. Get the indexPath of the selected cell from the table view.
4. Use `indexPath.row` to get the correct alarm that was tapped from the `AlarmController.shared.alarms` array.
5. Set the `alarm` property on the destination view controller equal to the above alarm.
* If the compiler presents an error when trying to do this, you either forgot to cast the destination view controller as an `AlarmDetailTableViewController` or forgot to give the `AlarmDetailTableViewController` a property title `alarm` of type `Alarm?`.
* At this point you should be able to run your project and see your table view populated with your mock alarms, displaying the proper switch state. You should also be able to delete rows, and segue to a detail view from a cell. This detail view should display the proper time of the alarm, the proper title, and the proper state of the enable/disable button.

### Final functionality on the detail view

Fill in the `saveButtonTapped` function on the detail view so that you can add new alarms and edit existing alarms.

1. Use `DateHelper.thisMorningAtMidnight` to find the time interval between this morning at midnight and the `datePicker.date`.
2. Unwrap `alarm` and if there is an alarm, call the `update(alarm:, fireTimeFromMidnight:, name:)` function from the `AlarmController` and pass it the time interval you just created and the title from the title text field.
3. If there is no alarm, call the `addAlarm(fireTimeFromMidnight:, name:)` function to create and add a new alarm.
* note: You should be able to run the project and have what appears to be a fully functional app. You should be able to add, edit, delete, and enable/disable alarms. We have not yet covered how to alert the user when time is up, so that part will not work yet, but we'll get there.

## Part Two - NSCoding, Protocol Extensions, UserNotifications

### Conform to the NSCoding Protocol

Make your `Alarm` object conforom to the NSCoding protocol so that we can persist alarms across app launches using NSKeyedArchiver and NSKeyedUnarchiver.

1. Adopt the NSCoding protocol and add the required `init?(coder aDecoder: NSCoder)` and `encode(with aCoder: NSCoder)` functions. You should review NSCoding in the documentation before continuing.
2. Inside each, you will use the NSCoder provided from the initializer or function to either encode your properties using `encode(_:, forKey:)` or decode your properties using `decodeObject(forKey:)`.
* note: It is best practice to create static internal keys to use in encoding and decoding (ex. `private let NameKey = "name"`)

### Persistence With NSKeyedArchiver and NSKeyedUnarchiver

Add persistence using NSKeyedArchiver and NSKeyedUnarchiver to the `AlarmController`. Archiving is similar to working with UserDefaults, but uses NSCoders to serialize and deserialize objects instead of our `init?(dictionary: [String: Any])` and `dictionaryRepresentation` functions. Both are valuable to know and be comfortable with.

NSKeyedArchiver serializes objects and saves them to a file on the device. NSKeyedUnarchiver pulls that file and deserializes the data back into our model objects.

Because of the way that iOS implements security and sandboxing, each application has it's own 'Documents' directory that has a different path each time the application is launched. When you want to write to or read from that directory, you need to first search for the directory, then capture the path as a reference to use where needed.

It is best to separate that logic into a separate function that returns the path. Here is an example function:

```
static private var persistentAlarmsFilePath: String? {
let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
guard let documentsDirectory = directories.first as NSString? else { return nil }
return documentsDirectory.appendingPathComponent("Alarms.plist")
}
```

This function accepts a string as a key and will return the path to a file in the Documents directory with that name.

1. Add a private, static, computed property called `persistentAlarmsFilePath` which returns the correct path to the alarms file in the app's documents directory as described above.
2. Write a private function called `saveToPersistentStorage()` that will save the current alarms array to a file using NSKeyedArchiver
* note: `NSKeyedArchiver.archiveRootObject(self.alarms, toFile: persistentAlarmsFilePath)`
3. Write a function called `loadFromPersistentStorage()` that will load saved Alarm objects and set self.alarms to the results
* note: Capture the data using `NSKeyedUnarchiver.unarchiveObject(withFile: persistentAlarmsFilePath)`, unwrap the Optional results and set self.alarms
4. Call the `loadFromPersistentStorage()` function when the AlarmController is initialized
5. Call the `saveToPersistentStorage()` any time that the list of alarms is modified
* note: You should now be able to see that your alarms are saved between app launches.

### Register the App for UserNotifications

Register for local notifications when the app launches.

1. In the `AppDelegate.swift` file import `UserNotifications`. Then in the `application(_:didFinishLaunchingWithOptions:)` function, request notification authorization on an instance of `UNUserNotificationCenter`.
* note: Use `UNUserNotificationCenter.current()` to get an instance of `UNUserNotificationCenter`

### Schedule and Cancel Local Notifications using a Custom Protocol and Extension

You will need to schedule local notifications each time you enable an alarm and cancel local notifications each time you disable an alarm. Seeing as you can enable/disable an alarm from both the list and detail view, we normally would need to write a `scheduleUserNotifications(for alarm: Alarm)` function and a `cancelUserNotifications(for alarm: Alarm)` function on both of our view controllers. However, using a custom protocol and a protocol extension, we can write those functions only once and use them in each of our view controllers as if we had written them in each view controller.

1. In your `AlarmController` file, but outside of the class, create a `protocol AlarmScheduler`. This protocol will need two functions: `scheduleUserNotifications(for alarm:)` and `cancelUserNotifications(for alarm: Alarm)`.
2. Below your protocol, create a protocol extension, `extension AlarmScheduler`. In there, you can create default implementations for the two protocol functions.
3. Your `scheduleUserNotifications(for alarm: Alarm)` function should create an instance of `UNMutableNotificationContent` and then give that instance a title and body. You can also give that instance a default sound to use when the notification goes off using `UNNotificationSound.default()`.
4. After you create your `UNMutableNotificationContent`, create an instance of `UNCalendarNotificationTrigger`. In order to do this you will need to create `DateComponents` using the `fireDate` of your `alarm`.
* note: Be sure to set `repeats` in the `UNCalendarNotificationTrigger` initializer to `true` so that the alarm will repeat daily at the specified time.
5. Now that you have `UNMutableNotificationContent` and a `UNCalendarNotificationTrigger`, you can initialize a `UNNotificationRequest` and add the request to the notification center object of your app.
* note: In order to initialize a `UNNotificationRequest` you will need a unique identifier. If you want to schedule multiple requests (which we do with this app) then you need a different identifier for each request. Thus, use the `uuid` property on your `Alarm` object as the identifier.
6. Your `cancelLocalnotification(for alarm: Alarm)` function simply needs to remove pending notification requests using the `uuid` property on the `Alarm` object you pass into the function.
* note: Look at documentation for `UNUserNotificationCenter` and see if there are any functions that will help you do this.
7. Now go to your list view controller and detail view controller and make them conform to the `AlarmScheduler` protocol. Notice how the compiler does not make you implement the schedule and cancel functions from the protocol? This is because by adding an extension to the protocol, we have created the implementation of these functions for all classes that conform to the protocol.
8. Go to your `AlarmListTableViewController`. In your `switchCellSwitchValueChanged` function, you will need to schedule a notification if the switch is being turned on, and cancel the notification if the switch is being turned off. You will also need to cancel the notification when you delete an alarm.
9. Go to your `AlarmDetailTableViewController`. Your `enableButtonTapped` action will need to either schedule or cancel a notification depending on its state, and will also need to call your `AlarmController.shared.toggleEnabled(for alarm: Alarm)` function if it isn't being called already. Your `saveButtonTapped` action will need to schedule a notification when saving a brand new alarm, and will need to cancel and re-save a notification when saving existing alarms (this is because the user may have changed the time for the alarm).

### UNUserNotificationCenterDelegate

The last thing you need to do is set up your app to notify the user when an alarm goes off and they still have the app open. In order to do this we are going to use the `UNUserNotificationCenterDelegate` protocol.

1. Go to your `AppDelegate.swift` file and have your `AppDelegate` class adopt the `UNUserNotificationCenterDelegate` protocol.
2. Then in your `application(_:didFinishLaunchingWithOptions:)` function, set the delegate of the notification center to equal `self`.
* note: `UNUserNotificationCenter.current().delegate = self`
3. Then implement the delegate method `userNotificationCenter(_:willPresent:withCompletionHandler:)` and use the `completionHandler` to set your `UNNotificationPresentationOptions`.
* note: `completionHandler([.alert, .sound])`

The app should now be finished. Run it, look for bugs, and fix anything that seems off.

## Contributions

Please refer to CONTRIBUTING.md.

## Copyright

© DevMountain LLC, 2015-2016. Unauthorized use and/or duplication of this material without express and written permission from DevMountain, LLC is strictly prohibited. Excerpts and links may be used, provided that full and clear credit is given to DevMountain with appropriate and specific direction to the original content.
