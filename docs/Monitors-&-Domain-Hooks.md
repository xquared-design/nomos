# Monitors & Domain Hooks

The new Domain model supports event hooks which allow you to do things when the data changes. Monitors are singleton registered plugins that make a clean place for you to organize your domain hooks.

All Domain objects have the following hooks:

(any event with Any on it is a static reference that will fire on any domain object of that type, otherwise they are instance methods and only apply to individual instances you hook).

    onBeforeChange (instance)
    onAnyBeforeChange (static)
    onChanged
    onAnyChanged
    onBeforeDelete
    onAnyBeforeDelete
    onDeleted
    onAnyDeleted
    onBeforeSave
    onAnyBeforeSave
    onSaved
    onAnySaved
    onBeforeCreate
    onAnyBeforeCreate
    onCreated
    onAnyCreated
    onBeforeUpdate
    onAnyBeforeUpdate
    onUpdated
    onAnyUpdated

E.g.

    User::onAnyCreated(function($user) {
        echo("Yay " . $user->username;
    });

These methods provide a reference to the object in it's state when the event is called. These events are called synchronously with the workflow of a domain, be smart. You can change domain data with this references. In order to determine exactly which fields change you'd have to cache a copy before and after an update and compare them.

### Monitors

Creating and registering a Monitor singleton is the recommended container for plugin style hooks of this type.

E.g.

    class UserMonitor extends Monitor {
        private $logger;
    
        public function Init(Logger $logger = null) {
            $this->logger = $logger;
    
            // function reference
            User::onAnyCreated([$this, "handleCreated"]);
    
            // inline function example
            User::onAnyUpdated(function($args) use ($this->logger) {
                $user = $args[0];
                $this->logger->log("{$user->username} updated!");
            });
    
            User::onAnyBeforeSave([$this, "handleBeforeSave"]);
            User::onAnySaved([$this, "handleSaved"]);
        }

        private function handleCreated($args) {
            $user = $args[0];
            $this->logger->log("{$user->username} updated!");
        }
    
        private function handleBeforeSave($args) {
            $user = $args[0];
            $user->notes = "This was updated by a monitor!";
        }
    
        private function handleSaved($args) {
            $user = $args[0];
            $this->logger->log("{$user->notes}"); // would return "This was updated by a monitor!"
        }
    }

### app registration:

    // In a static context initialize the monitor
    \app\monitors\UserMonitor::getInstance()->Init($serverLog);

