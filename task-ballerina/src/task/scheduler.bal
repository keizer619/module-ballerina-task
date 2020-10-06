// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Represents a ballerina task Scheduler, which can be used to run jobs periodically, using the given configurations.
public class Scheduler {
    private Listener taskListener;

    # Initializes a `task:Scheduler` object. This may panic if the initialization causes any error due to
    # a configuration error.
    #
    # + configuration - The configurations associated with the `task:Scheduler`
    # + misfireConfiguration - The `task:MisfireConfiguration` record which is used to configure the misfire situations
    #                          of the scheduler
    public isolated function init(TimerConfiguration|AppointmentConfiguration configuration,
                                  MisfireConfiguration misfireConfiguration = {}) {
        self.taskListener = new(configuration, misfireConfiguration);
    }

    # Attaches the provided `service` to the task.
    #
    # + serviceToAttach - Ballerina `service` object, which needs to be attached to the task
    # + attachments - Set of optional parameters, which need to be passed inside the resources
    # + return - A `task:SchedulerError` if the process failed due to any reason or else ()
    public isolated function attach(service serviceToAttach, any... attachments) returns SchedulerError? {
        var result = attachExternal(self.taskListener, serviceToAttach, ...attachments);
        if (result is ListenerError) {
            string message = "Failed to attach the service to the scheduler";
            return SchedulerError(message, result);
        }
    }

    # Detaches the provided `service` from the task.
    #
    # + attachedService - Ballerina `service` object, which needs to be detached from the task
    # + return - A `task:SchedulerError` if the process failed due to any reason or else ()
    public isolated function detach(service attachedService) returns SchedulerError? {
        var result = detachExternal(self.taskListener, attachedService);
        if (result is ListenerError) {
            string message = "Scheduler failed to detach the service";
            return SchedulerError(message, result);
        }
    }

    # Starts running the task. Task Scheduler will not run until this has been called.
    #
    # + return - A `task:SchedulerError` if the process failed due to any reason or else ()
    public isolated function 'start() returns SchedulerError? {
        var result = startExternal(self.taskListener);
        if (result is ListenerError) {
            string message = "Scheduler failed to start";
            return SchedulerError(message, result);
        }
    }

    # Stops the task. This will stop after running the existing jobs.
    #
    # + return - A `task:SchedulerError` if the process failed due to any reason or else ()
    public isolated function stop() returns SchedulerError? {
        var result = stopExternal(self.taskListener);
        if (result is ListenerError) {
            string message = "Scheduler failed to stop";
            return SchedulerError(message, result);
        }
    }

    # Pauses the task.
    #
    # + return - A `task:SchedulerError` if an error is occurred while pausing or else ()
    public isolated function pause() returns SchedulerError? {
        var result = pauseExternal(self.taskListener);
        if (result is ListenerError) {
            string message = "Scheduler failed to pause";
            return SchedulerError(message, result);
        }
    }

    # Resumes a paused task.
    #
    # + return - A `task:SchedulerError` when an error occurred while resuming or else ()
    public isolated function resume() returns SchedulerError? {
        var result = resumeExternal(self.taskListener);
        if (result is ListenerError) {
            string message = "Scheduler failed to resume";
            return SchedulerError(message, result);
        }
    }

    # Checks whether the task listener is started or not.
    #
    # + return - `true` if the `Scheduler` is already started or else `false` if the `Scheduler` is
    #            not started yet or stopped calling the `Scheduler.stop()` function
    public isolated function isStarted() returns boolean {
        return self.taskListener.isStarted();
    }
}
