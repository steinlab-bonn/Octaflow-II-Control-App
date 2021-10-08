classdef Octaflow_control_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        OctaflowIIControlAppUIFigure  matlab.ui.Figure
        BreakPushedLabel              matlab.ui.control.Label
        ManualButton                  matlab.ui.control.Button
        TextArea_17                   matlab.ui.control.TextArea
        ClosePanel                    matlab.ui.container.Panel
        CloseLabel                    matlab.ui.control.Label
        ConnectionlostPanel           matlab.ui.container.Panel
        TextArea_4                    matlab.ui.control.TextArea
        TabGroup                      matlab.ui.container.TabGroup
        DirectModeTab                 matlab.ui.container.Tab
        DirectModePanel               matlab.ui.container.Panel
        DirectTextArea_8              matlab.ui.control.TextArea
        DirectTextArea_7              matlab.ui.control.TextArea
        DirectTextArea_6              matlab.ui.control.TextArea
        DirectTextArea_5              matlab.ui.control.TextArea
        DirectTextArea_4              matlab.ui.control.TextArea
        DirectTextArea_3              matlab.ui.control.TextArea
        DirectTextArea_2              matlab.ui.control.TextArea
        DirectTextArea_1              matlab.ui.control.TextArea
        DirectclosevalveSwitch        matlab.ui.control.Switch
        closevalveSwitchLabel         matlab.ui.control.Label
        DirectOntimesSpinner          matlab.ui.control.Spinner
        OntimesSpinnerLabel           matlab.ui.control.Label
        pressurepsiSpinner_2          matlab.ui.control.Spinner
        pressurepsiSpinner_2Label     matlab.ui.control.Label
        DirectOntimeLabel             matlab.ui.control.Label
        DirectAlt4Button              matlab.ui.control.StateButton
        DirectAlt3Button              matlab.ui.control.StateButton
        DirectAlt2Button              matlab.ui.control.StateButton
        DirectAlt1Button              matlab.ui.control.StateButton
        DirectFlushButton             matlab.ui.control.StateButton
        DirectValve8Button            matlab.ui.control.StateButton
        Valve7Button                  matlab.ui.control.StateButton
        DirectValve6Button            matlab.ui.control.StateButton
        DirectValve5Button            matlab.ui.control.StateButton
        DirectValve4Button            matlab.ui.control.StateButton
        DirectValve3Button            matlab.ui.control.StateButton
        DirectValve2Button            matlab.ui.control.StateButton
        Valve1Button                  matlab.ui.control.StateButton
        SequenceTab                   matlab.ui.container.Tab
        SequencePanel                 matlab.ui.container.Panel
        SequenceCheckBox              matlab.ui.control.CheckBox
        SequenceDeleteallButton       matlab.ui.control.Button
        SequenceLamp                  matlab.ui.control.Lamp
        SequenceSeqEditPanel          matlab.ui.container.Panel
        SequenceSpecialDropDown       matlab.ui.control.DropDown
        SequenceOnTime                matlab.ui.control.NumericEditField
        SequenceWaitTimeAfter         matlab.ui.control.NumericEditField
        SequencePressureSpinner       matlab.ui.control.Spinner
        SequenceValveSpinner          matlab.ui.control.Spinner
        SequenceStepSpinner           matlab.ui.control.Spinner
        SequenceDeletestepButton      matlab.ui.control.Button
        SequenceDeleteSpinner         matlab.ui.control.Spinner
        SequenceStepStandbyLabel      matlab.ui.control.Label
        SequenceStartsequenceButton   matlab.ui.control.Button
        SequenceAddstepButton         matlab.ui.control.Button
        SequenceTable                 matlab.ui.control.Table
        PrimingTab                    matlab.ui.container.Tab
        PrimingPanel                  matlab.ui.container.Panel
        PrimingValvedirectionSwitch   matlab.ui.control.Switch
        valvedirectionSwitchLabel     matlab.ui.control.Label
        PrimingWaittimeSpinnerLabel   matlab.ui.control.Label
        PrimingSpecialDropDown        matlab.ui.control.DropDown
        PrimingTimerTextArea          matlab.ui.control.TextArea
        PrimingTimer                  matlab.ui.control.Gauge
        PrimingLamp                   matlab.ui.control.Lamp
        PrimingWaittimeSpinner        matlab.ui.control.Spinner
        waittimebetweenvalvessSpinnerLabel_3  matlab.ui.control.Label
        PrimingLoopStandbyLabel       matlab.ui.control.Label
        PrimingValveStandbyLabel      matlab.ui.control.Label
        PrimingOntimevalvesSpinner    matlab.ui.control.Spinner
        openingtimevalvesLabel        matlab.ui.control.Label
        PrimingStartButton            matlab.ui.control.Button
        PrimingPressurepsiSpinner     matlab.ui.control.Spinner
        pressurepsiSpinner_3Label     matlab.ui.control.Label
        PrimingLoopsSpinner           matlab.ui.control.Spinner
        LoopsSpinnerLabel             matlab.ui.control.Label
        CleaningTab                   matlab.ui.container.Tab
        CleaningPanel                 matlab.ui.container.Panel
        CleaningQuickflushButton      matlab.ui.control.Button
        CleaningCheckBox              matlab.ui.control.CheckBox
        CleaningLamp                  matlab.ui.control.Lamp
        CleaningTimerTextArea         matlab.ui.control.TextArea
        CleaningTimer                 matlab.ui.control.Gauge
        CleaningTimeSpinner           matlab.ui.control.Spinner
        timeminSpinnerLabel           matlab.ui.control.Label
        CleaningStartButton           matlab.ui.control.Button
        CleaningpressurepsiSpinner    matlab.ui.control.Spinner
        pressurepsiSpinnerLabel       matlab.ui.control.Label
        AboutTab                      matlab.ui.container.Tab
        AboutPanel                    matlab.ui.container.Panel
        AboutTextArea                 matlab.ui.control.TextArea
        StartSwitchonOctaflowIIsystemLabel  matlab.ui.control.Label
        StartTextArea_2               matlab.ui.control.TextArea
        StartAppButton                matlab.ui.control.Button
        SynconButton                  matlab.ui.control.StateButton
        BreakButton                   matlab.ui.control.Button
        StartTextArea_1               matlab.ui.control.TextArea
    end

    %%Octaflow II Control App V1.0 (October 2021) by Michael Rabenstein
    %%Connection to device via CyUSB.dll adapted from code provided by
    %%anonymous user on the Feb 19, 2015 04:41 AM at
    %%https://community.cypress.com/t5/USB-Low-Full-High-Speed/CyUSB-dll-in-MATLAB-problems-at-indexing-a-device-list/m-p/58551 (last access 04/13/2021)

    properties (Access = private)
        Octaflow %Octaflow II (tm) device properties
        CyUSBdll %dll properties
        BulkOutEndPt %Send data out to device properties
        BulkInEndPt %Fetch data from device properties

        programm_running = 0; %Used to signal app.device_connected() if the app will be closed
        startup_1 %Byte command to make Octaflow II (tm) system ready
        startup_2 %Byte command to make Octaflow II (tm) system ready
        shutdown %Byte command to shut Octaflow Octaflow II (tm) system down
        valves_off %Byte command to switch of valve
        sync_on %Byte command to switch on Sync out TTL pulse of the Octaflow II (tm) system
        sync_off %Byte command to switch off Sync out TTL pulse of the Octaflow II (tm) system
        sync_valve_off %Byte command to send out TTL pulse of the Octaflow II (tm) system. Used when last valves closes
        breaker = 0; %Value used for stopping loops when 'Break'-button is pushed
        loop_time = 0; %wait time for stopping loops when 'Break'-button is pushed
        priming_hex %Table containing hex-strings to switch on valves during priming sequence
        timer_command %Control property for timer while loops
        flush %Byte command to switch on flush valve
        sequence_table %Table containing Bulkout bytes, valve ontime, step waittime and special valve status for valve sequence execution
        close_request = 0; %Value used for stopping start up device search loop when app will be closed

        % %     16 Byte string is used for valve control:
        % %     1. Byte: 02 control settings? (Sync:01, valve:02 shut down:08)
        % %     2. Byte: 00 sync off:00, sync on: 01
        % %     3. Byte: 00 sync + alternativ valves (Sync:08, flush:10,
        % %            Alt1:20, Alt2:40, Alt3:01, Alt4:02).
        % %     4. Byte: 00 valve control part 1
        % %     5. Byte: 00 ?
        % %     6. Byte: 00 ?
        % %     7. Byte: 00 ?
        % %     8. Byte: C8 ?
        % %     9. Byte: 0A ?
        % %     10. Byte: 00 valve control part 2
        % %     11. Byte: 0C pressure control part 1
        % %     12. Byte: 00 pressure control part 2
        % %     13. Byte: 00 ?
        % %     14. Byte: 00 ?
        % %     15. Byte: 00 ?
        % %     16. Byte: 00 for cleaning 27


        valves_off_hex =  '02000000000000C80A000C0000000000';

        sync_table=[...%Replaces bytes 1-3
            '010108';... %Sync_on
            '010008';... %Sync_off
            ];

        valve_table=[... %Replaces bytes 4-10
            '00000000C80A00';... %Valve_off
            '02000000C80A08';... %Valve_1
            '08000000C80A11';... %Valve_2
            '01000000C80A19';... %Valve_3
            '04000000C80A22';... %Valve_4
            '10000000C80A2A';... %Valve_5
            '80000000C80A33';... %Valve_6
            '20000000C80A3C';... %Valve_7
            '40000000C80A44';... %Valve_8
            'FF000000C80A44';... %Valve_all
            ];

        extravalve_table=[... %Replaces byte 3
            '00';... %Extra_off
            '10';... %Flush
            '20';... %Alt_1
            '40';... %Alt_2
            '01';... %Alt_3
            '02';... %Alt_4
            ];

        extravalve_table_dec=[... %Replaces byte 3
            0;... %Extra_off
            16;... %Flush
            32;... %Alt_1
            64;... %Alt_2
            1;... %Alt_3
            2;... %Alt_4
            ];


        pressure_table=[... %Replaces bytes 11-12
            '0C00';... %0 psi
            '2E00';... %1
            '4700';... %2
            '6700';... %3
            '8A00';... %4
            'AD00';... %5
            'D000';... %6
            'F300';... %7
            '1601';... %8
            '3901';... %9
            '5C01';... %10
            '7F01';... %11
            'A201';... %12
            'C501';... %13
            'E801';... %14
            '0B02';... %15
            '2E02';... %16
            '5102';... %17
            '7402';... %18
            '9702';... %19
            'BB02';... %20
            'DE02';... %21
            '0103';... %22
            '2403';... %23
            '4703';... %24
            '6A03';... %25
            '8D03';... %26
            'B003';... %27
            'D303';... %28
            'E803';... %29
            'E803';... %Readed out as 30, but same as 29 psi
            ];


        priming_valves_table =[...
            '02000002000000C80A080C0000000000';... %Valve_1
            '02000008000000C80A110C0000000000';... %Valve_2
            '02000001000000C80A190C0000000000';... %Valve_3
            '02000004000000C80A220C0000000000';... %Valve_4
            '02000010000000C80A2A0C0000000000';... %Valve_5
            '02000080000000C80A330C0000000000';... %Valve_6
            '02000020000000C80A3C0C0000000000';... %Valve_7
            '02000040000000C80A440C0000000000';... %Valve_8
            ];

    end

    methods (Access = private)

        function device_connected(app) %Should check in the background if the connection to the device is lost or emergency sutdown was initiated
            programm_running = 1;
            while programm_running == 1 %Will set to 0 if app is closed, stopping the function




                device_present = 0;
                usbdev = CyUSB.USBDeviceList(CyUSB.CyConst.DEVICES_CYUSB); %Loading all connected devices of the dll
                if ~(usbdev.Count == 0) %if at least one device is connected...
                    for i = 1:usbdev.Count %...screen the device list
                        Octaflow_local = handle(usbdev.Item((i-1)));
                        if eq(Octaflow_local.Name,'Octaflow ') %...and check if one of the devices is the Octaflow II (tm) system
                            device_present = 1;
                            break
                        end
                    end
                end
                if device_present == 1
                    pause(2); %if device is present, wait for 2s before next check
                else
                    app.reset_all() %Reset the buttons
                    app.TabGroup.Visible = 0; %hide the tab group
                    app.ConnectionlostPanel.Visible = 1; %...and show the information window
                    while device_present == 0 %stops loop when app is closed, when device is not connected
                        try %Stops function if app is closed
                            programm_running = app.programm_running;
                        catch
                            return
                        end

                        %             if programm_running == 0;
                        %               break
                        %             end

                        usbdev = CyUSB.USBDeviceList(CyUSB.CyConst.DEVICES_CYUSB); %Loading all connected devices of the dll
                        if ~(usbdev.Count == 0) %if at least one device is connected...
                            for i = 1:usbdev.Count %...screen the device list
                                Octaflow_local = handle(usbdev.Item((i-1)));
                                if eq(Octaflow_local.Name,'Octaflow ') %...and check if one of the devices is the Octaflow II (tm) system
                                    app.Octaflow = Octaflow_local;
                                    app.BulkOutEndPt = app.Octaflow.EndPointOf(0x02); %update the BulkOutEndPt property
                                    app.BulkInEndPt = app.Octaflow.EndPointOf(0x81); %update the BulkInEndPt property
                                    app.connect() %Restart the device


                                    app.TabGroup.Visible = 1; %Make the control area visible
                                    app.ConnectionlostPanel.Visible = 0;
                                    app.StartAppButton.Visible = 0;
                                    device_present = 1;
                                    break
                                end
                            end
                        end
                        if device_present == 0
                            pause(5); %if device is not present, wait for 5s before next check
                        end
                    end
                end
                try %Stops function if app is closed
                    programm_running = app.programm_running;
                catch
                    return
                end
            end
        end


        function reset_all(app) %Reset all state buttons
            app.Valve1Button.Value = 0;
            app.DirectValve2Button.Value = 0;
            app.DirectValve3Button.Value = 0;
            app.DirectValve4Button.Value = 0;
            app.DirectValve5Button.Value = 0;
            app.DirectValve6Button.Value = 0;
            app.Valve7Button.Value = 0;
            app.DirectValve8Button.Value = 0;
            app.DirectFlushButton.Value = 0;
            app.DirectAlt1Button.Value = 0;
            app.DirectAlt2Button.Value = 0;
            app.DirectAlt3Button.Value = 0;
            app.DirectAlt4Button.Value = 0;
        end

        function reset_normal_valves(app) %Reset single valve state buttons
            app.Valve1Button.Value = 0;
            app.DirectValve2Button.Value = 0;
            app.DirectValve3Button.Value = 0;
            app.DirectValve4Button.Value = 0;
            app.DirectValve5Button.Value = 0;
            app.DirectValve6Button.Value = 0;
            app.Valve7Button.Value = 0;
            app.DirectValve8Button.Value = 0;
        end


        function connect(app) %Send start up commands to device
            BulkOutEndPt_local = app.BulkOutEndPt;
            BulkOutEndPt_local.XferData(app.startup_1,2);
            BulkOutEndPt_local.XferData(app.startup_2,16);
            BulkOutEndPt_local.XferData(app.valves_off,16);
        end

        function bulkout(app,byte_out) %Sends 16 byte commands to device
            BulkOutEndPt_local = app.BulkOutEndPt;
            BulkOutEndPt_local.XferData(byte_out,16);

        end


        function byte = byte_converter(~, command_hex) %Converts ASCII-hex character vector to ASCII-dec matrix, which can be send to device
            byte = sscanf(command_hex, '%2x');

        end
        function single_valve(app,state,valve_selected) %Function used to control valves in single valve modus
            %%State: valve button on/off; valve_selected: pushed valve
            %%button

            app.breaker = 0; %Reset breaker property
            breaker = 0; %set local breaker
            app.loop_time = 0; %Reset loop_time property
            app.timer_command = 1; %Reset timer_command

            %%Deactivate unneeded control buttons to prevent confusion

            app.pressurepsiSpinner_2.Enable = 0;
            app.DirectclosevalveSwitch.Enable = 0;
            app.DirectFlushButton.Enable = 0;
            app.SynconButton.Enable = 0;
            app.DirectAlt1Button.Enable = 0;
            app.DirectAlt2Button.Enable = 0;
            app.DirectAlt3Button.Enable = 0;
            app.DirectAlt4Button.Enable = 0;
            app.SequencePanel.Enable = 'off';
            app.PrimingPanel.Enable = 'off';
            app.CleaningPanel.Enable = 'off';
            app.AboutPanel.Enable = 'off';


            if state == 1 %If valve is switched on

                %%Deactivate other valve buttons
                if ~(valve_selected == 1)
                    app.Valve1Button.Value = 0;
                end
                if ~(valve_selected == 2)
                    app.DirectValve2Button.Value = 0;
                end
                if ~(valve_selected == 3)
                    app.DirectValve3Button.Value = 0;
                end
                if ~(valve_selected == 4)
                    app.DirectValve4Button.Value = 0;
                end
                if ~(valve_selected == 5)
                    app.DirectValve5Button.Value = 0;
                end
                if ~(valve_selected == 6)
                    app.DirectValve6Button.Value = 0;
                end
                if ~(valve_selected == 7)
                    app.Valve7Button.Value = 0;
                end
                if ~(valve_selected == 8)
                    app.DirectValve8Button.Value = 0;
                end

                hexout = app.valves_off_hex; %copy switch off command for local editing

                hexout(7:20) = app.valve_table((valve_selected + 1),:); %Add selected valve characters to send out command
                hexout(21:24) = app.pressure_table((app.pressurepsiSpinner_2.Value)+1,:); %Add selected pressure characters to send out command

                %%Check if Alt-valve is selected and generate send out
                %%command
                hexout_special = hexout;
                if app.DirectAlt1Button.Value == 1
                    hexout_special(5:6) = app.extravalve_table(3,:);
                elseif app.DirectAlt2Button.Value == 1
                    hexout_special(5:6) = app.extravalve_table(4,:);
                elseif app.DirectAlt3Button.Value == 1
                    hexout_special(5:6) = app.extravalve_table(5,:);
                elseif app.DirectAlt4Button.Value == 1
                    hexout_special(5:6) = app.extravalve_table(6,:);
                end

                app.bulkout(app.valves_off) %Send switch off command

                %%Convert valve command and send it out
                hexout_byte = app.byte_converter(hexout);
                app.bulkout(hexout_byte)

                %%If Alt-valve is selected, send the command out
                if ~(eq(string(hexout_special),string(hexout)))
                    hexout_special_byte = app.byte_converter(hexout_special);
                    app.bulkout(hexout_special_byte)
                end


                if app.DirectclosevalveSwitch.Value == 0 %If not specific valve open time was selected, start timer
                    valve_on_timer(app)
                end


                if app.DirectclosevalveSwitch.Value == 1 %%If specific valve open time was selected
                    app.DirectModePanel.Enable = 'off'; %Deactivate valve panel
                    app.valvebutton_disable(); %Deactivate valve buttons

                    full_loops = floor(app.DirectOntimesSpinner.Value / 5); %Calculate full 5 s loops for break option
                    rest_time = rem(app.DirectOntimesSpinner.Value, 5); %Calculate rest time for break option
                    for i = 1:full_loops
                        pause(5)
                        try
                            breaker = app.breaker; %Check if break button was pushed
                        catch
                            return
                        end
                        if breaker == 1
                            break
                        end
                    end
                    if breaker == 0
                        pause(rest_time) %Wait for selected open time
                    end

                    app.bulkout(app.valves_off) %Switch valves off

                    %%Reset and reactivate control buttons
                    app.reset_normal_valves()
                    app.DirectOntimesSpinner.Enable = 1;
                    app.pressurepsiSpinner_2.Enable = 1;
                    app.DirectclosevalveSwitch.Enable = 1;
                    app.valvebutton_enable();
                    app.DirectModePanel.Enable = 'on';
                    app.SequencePanel.Enable = 'on';
                    app.PrimingPanel.Enable = 'on';
                    app.CleaningPanel.Enable = 'on';
                    app.AboutPanel.Enable = 'on';

                    %%If Flush valve is selected, send out command
                    if app.DirectFlushButton.Value == 1
                        app.bulkout(app.valves_off)
                        app.bulkout(app.flush);
                    end

                end

            else %In case valve is switched of
                app.bulkout(app.valves_off) %Switch valves off
                app.valvebutton_enable();
                app.DirectOntimesSpinner.Enable = 1;
                app.pressurepsiSpinner_2.Enable = 1;
                app.DirectclosevalveSwitch.Enable = 1;
                app.SequencePanel.Enable = 'on';
                app.PrimingPanel.Enable = 'on';
                app.CleaningPanel.Enable = 'on';
                app.AboutPanel.Enable = 'on';


                if app.SynconButton.Value == 1 %In case Sync is on, valve double command. Necessary for the device to send out a TTL pulse after closing last valve
                    app.bulkout(app.sync_valve_off);
                    app.bulkout(app.valves_off)
                end
                %%If Flush valve is selected, send out command
                if app.DirectFlushButton.Value == 1
                    app.bulkout(app.valves_off)
                    app.bulkout(app.flush);
                end
            end
            app.timer_command = 0; %Reset timer command
        end

        function valvebutton_enable(app) %Enable all single valve buttons
            app.Valve1Button.Enable = 1;
            app.DirectValve2Button.Enable = 1;
            app.DirectValve3Button.Enable = 1;
            app.DirectValve4Button.Enable = 1;
            app.DirectValve5Button.Enable = 1;
            app.DirectValve6Button.Enable = 1;
            app.Valve7Button.Enable = 1;
            app.DirectValve8Button.Enable = 1;
            app.DirectFlushButton.Enable = 1;
            app.SynconButton.Enable = 1;
            app.DirectAlt1Button.Enable = 1;
            app.DirectAlt2Button.Enable = 1;
            app.DirectAlt3Button.Enable = 1;
            app.DirectAlt4Button.Enable = 1;
        end

        function valvebutton_disable(app) %Disable all single valve buttons
            app.Valve1Button.Enable = 0;
            app.DirectValve2Button.Enable = 0;
            app.DirectValve3Button.Enable = 0;
            app.DirectValve4Button.Enable = 0;
            app.DirectValve5Button.Enable = 0;
            app.DirectValve6Button.Enable = 0;
            app.Valve7Button.Enable = 0;
            app.DirectValve8Button.Enable = 0;
            app.DirectFlushButton.Enable = 0;
            app.SynconButton.Enable = 0;
            app.DirectAlt1Button.Enable = 0;
            app.DirectAlt2Button.Enable = 0;
            app.DirectAlt3Button.Enable = 0;
            app.DirectAlt4Button.Enable = 0;

        end
        function break_all(app) %Break function to stop device.
            app.breaker = 1; %Set break property to 1 to stop loops
            pause(app.loop_time); %Wait for longest step in the loops

            app.bulkout(app.valves_off) %Stop valves

            %%Reset control buttons
            app.reset_all()
            app.DirectOntimesSpinner.Enable = 1;
            app.pressurepsiSpinner_2.Enable = 1;
            app.DirectclosevalveSwitch.Enable = 1;
            app.valvebutton_enable();
            app.DirectModePanel.Enable = 'on';
            app.SequencePanel.Enable = 'on';
            app.PrimingPanel.Enable = 'on';
            app.CleaningPanel.Enable = 'on';
            app.AboutPanel.Enable = 'on';
            app.timer_command = 0;

            %%If Flush valve is selected, send out command
            if app.DirectFlushButton.Value == 1
                app.bulkout(app.flush);
            end
            app.BreakPushedLabel.Visible = 0;
        end

        function close_app(app) %Close app function
            app.programm_running = 0; %Stop property for device_connected() function
            app.breaker = 1; %Induce loop breaking
            app.close_request = 1; %Set close request property


            if app.loop_time < 6 %Wait for at least 6s to let loops correctly stops
                waittime = 6;
            else
                waittime = app.loop_time;
            end
            pause(waittime)
            if (app.ConnectionlostPanel.Visible == 0 && ~(isempty(app.BulkOutEndPt)))  %In case device was once and is still connected
                app.BulkOutEndPt.XferData(app.shutdown,16); %Send out shut down command to device
            end
            delete(app) %Close app
        end

        function priming_hex_calc(app) %Generate hex command table for valve priming

            priming_valves_table_local = app.priming_valves_table; %Generate local copy of table with valve hex codes

            for i = 1:8 %%Add pressure hex to every valve, convert hex to dec and save to property
                priming_valves_table_cache = priming_valves_table_local(i,:);
                priming_valves_table_cache(21:24) = app.pressure_table((app.PrimingPressurepsiSpinner.Value)+1,:);
                priming_valves_table_cache_hex = app.byte_converter(priming_valves_table_cache);
                app.priming_hex(:,i) = priming_valves_table_cache_hex;
            end

        end

        function valve_on_timer(app) %Timer for single valve mode
            timer_command = app.timer_command;
            tic
            while timer_command == 1 %Till timer is stopped, refresh OntimeLabel every second
                pause(1)
                app.DirectOntimeLabel.Text = sprintf('On time %s', datestr(seconds(toc),'MM:SS'));
                timer_command = app.timer_command;
            end
            app.DirectOntimeLabel.Text = sprintf('On time %s', datestr(seconds(0),'MM:SS')); %reset timer label


        end

        function reset_special_valve(app,valve_selected) %%Prevents selecting more than one special valve
            app.bulkout(app.valves_off)
            if ~(valve_selected == 1)
                app.DirectFlushButton.Value = 0;
            end
            if ~(valve_selected == 2)
                app.DirectAlt1Button.Value = 0;
            end
            if ~(valve_selected == 3)
                app.DirectAlt2Button.Value = 0;
            end
            if ~(valve_selected == 4)
                app.DirectAlt3Button.Value = 0;
            end
            if ~(valve_selected == 5)
                app.DirectAlt4Button.Value = 0;
            end

        end



    end



    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            pause(2)
            app.OctaflowIIControlAppUIFigure.Name = 'OctaflowII Control App v1.0';

            %%Put panels in position

            movegui(app.OctaflowIIControlAppUIFigure,'center');
            app.ConnectionlostPanel.Visible = 0;
            app.BreakPushedLabel.Visible = 0;
            app.ClosePanel.Visible = 0;
            app.ConnectionlostPanel.Position = [0,0,638,508];
            app.BreakPushedLabel.Position = [163,224, 306,64];
            app.ClosePanel.Position = [0,0,638,508];

            %             path = ctfroot;
            %             dllpath = fullfile(path,'CyUSB.dll');

            try %%Load CyUSB dll (https://community.cypress.com/t5/USB-Low-Full-High-Speed/CyUSB-dll-in-MATLAB-problems-at-indexing-a-device-list/m-p/58555/highlight/true#M1224)
                app.CyUSBdll = NET.addAssembly(which('CyUSB.dll')); %CyUSB.dll v.1.2.3.0 necessary (CyUSB.dll v.1.2.2.0 provided with the Octaflow II(tm) control software)
                %%Not used fragments from the loading code
                %         app.CyUSBdll = NET.addAssembly('C:\Users\Rabenstein\Documents\MATLAB\MichaelR\Octaflow\CyUSB.dll');
                %         app.CyUSBdll = CyUSBdll;
                %       catch error
                %         error.message
                %         if(isa(error,'NET.NetException'))
                %           e.ExceptionObject
                %         else
                %           disp('CyUSB.dll already loaded');
                %           return;
                %         end
            end

            %%Check if Octaflow II (tm) system is connected
            device_present = 0;
            while device_present == 0
                try %Stops function if app is closed
                    programm_running = app.programm_running;
                catch
                    return
                end

                usbdev = CyUSB.USBDeviceList(CyUSB.CyConst.DEVICES_CYUSB); %Generate device list
                if ~(usbdev.Count == 0) %if at least one device is connected
                    %         if ~isempty(usbdev)
                    for i = 1:usbdev.Count %for every connected device
                        Octaflow_local = handle(usbdev.Item((i-1))); %Fetch device
                        if eq(Octaflow_local.Name,'Octaflow ') %Check if device is the Octaflow II (tm) system
                            device_present = 1;
                            app.Octaflow = Octaflow_local; %write Octaflow II (tm) informations to property
                            app.BulkOutEndPt = app.Octaflow.EndPointOf(0x02); %define output channel
                            app.StartSwitchonOctaflowIIsystemLabel.Visible = 0; %Remove the reminder to connect the Octaflow II (tm) system
                            app.programm_running = 1;

                            break %break for-loop if the Octaflow II (tm) system was detected
                        end
                    end
                else
                    app.StartSwitchonOctaflowIIsystemLabel.Visible = 1; %Make the reminder to connect the Octaflow II (tm) system visible
                end


                try
                    breaker = app.close_request; %Break loop if app will be shut down
                catch
                    return

                end

                if device_present == 0
                    pause(1)

                end



            end
            app.startup_1 =   app.byte_converter('7BC4');
            app.startup_2 =   app.byte_converter('01000000000000000000000000000000');
            app.shutdown =   app.byte_converter('08000000000000C80A000C0000000000');
            app.valves_off =  app.byte_converter('02000000000000C80A000C0000000000');
            app.sync_on =    app.byte_converter('01010800000000C80A000C0000000000');
            app.sync_off =   app.byte_converter('01000800000000C80A000C0000000000');
            app.flush =     app.byte_converter('02001000000000C80A000C0000000000');
            app.sync_valve_off = app.byte_converter(app.priming_valves_table(1,:));


            app.connect() %Start device
            app.BulkOutEndPt.XferData(app.sync_on,16); %Activate sync out of the Octaflow II (tm) system
            app.priming_hex_calc();

            app.DirectOntimeLabel.Text = sprintf('On time %s', datestr(seconds(0),'MM:SS')); %Settimeer label


            app.StartAppButton.Enable = 1; %Enable button to close startup window

            app.CleaningTimer.Value = app.CleaningTimeSpinner.Value;
            app.device_connected() %Start function for continuous check if device is still present

        end

        % Close request function: OctaflowIIControlAppUIFigure
        function OctaflowIIControlAppUIFigureCloseRequest(app, event)
            %             app.ClosePanel.Visible = 1; %Make shutdown window visible

            selection = uiconfirm(app.OctaflowIIControlAppUIFigure,'Do you want to close the app?','Confirm Close', 'Icon','warning');
            if eq(selection, 'OK')
                app.ClosePanel.Visible = 1; %Make shutdown window visible
app.CloseLabel.Text = 'Closing app...';
                app.close_app();
            end

        end

        % Button pushed function: StartAppButton
        function StartAppButtonPushed(app, event)
            app.TabGroup.Visible = 1;
            app.SynconButton.Visible = 1;
            app.BreakButton.Visible = 1;
            app.StartTextArea_1.Visible = 1;
            app.StartAppButton.Visible = 0;
        end

        % Value changed function: DirectclosevalveSwitch
        function DirectclosevalveSwitchValueChanged(app, event)
            %%Switch between manual and timer based mode for closing single
            %%valves and make necessary controls visible

            value = app.DirectclosevalveSwitch.Value;
            if value == 1
                app.DirectOntimesSpinner.Visible = 1;
                app.OntimesSpinnerLabel.Visible = 1;
                app.DirectOntimeLabel.Visible = 0;
            elseif value == 0
                app.DirectOntimesSpinner.Visible = 0;
                app.OntimesSpinnerLabel.Visible = 0;
                app.DirectOntimeLabel.Visible = 1;
            end

        end

        % Value changed function: Valve1Button
        function Valve1ButtonValueChanged(app, event)
            state = app.Valve1Button.Value;
            valve = 1;
            app.single_valve(state,valve) %Send button state and valve number to single valve function

        end

        % Value changed function: DirectValve2Button
        function DirectValve2ButtonValueChanged(app, event)
            state = app.DirectValve2Button.Value;
            valve = 2;
            app.single_valve(state,valve)

        end

        % Value changed function: DirectValve3Button
        function DirectValve3ButtonValueChanged(app, event)
            state = app.DirectValve3Button.Value;
            valve = 3;
            app.single_valve(state,valve)

        end

        % Value changed function: DirectValve4Button
        function DirectValve4ButtonValueChanged(app, event)
            state = app.DirectValve4Button.Value;
            valve = 4;
            app.single_valve(state,valve)

        end

        % Value changed function: DirectValve5Button
        function DirectValve5ButtonValueChanged(app, event)
            state = app.DirectValve5Button.Value;
            valve = 5;
            app.single_valve(state,valve)

        end

        % Value changed function: DirectValve6Button
        function DirectValve6ButtonValueChanged(app, event)
            state = app.DirectValve6Button.Value;
            valve = 6;
            app.single_valve(state,valve)

        end

        % Value changed function: Valve7Button
        function DirectValve7ButtonValueChanged(app, event)
            state = app.Valve7Button.Value;
            valve = 7;
            app.single_valve(state,valve)

        end

        % Value changed function: DirectValve8Button
        function DirectValve8ButtonValueChanged(app, event)
            state = app.DirectValve8Button.Value;
            valve = 8;
            app.single_valve(state,valve)

        end

        % Button pushed function: BreakButton
        function BreakButtonPushed(app, event)
            app.BreakPushedLabel.Visible = 1; %Show break label
            break_all(app) %Stops all valves/ breaks loops and reset buttons
        end

        % Button pushed function: PrimingStartButton
        function PrimingStartButtonPushed(app, event)
            %%Starts Priming Sequence

            app.breaker = 0; %Set breaker property
            breaker = 0;
            app.PrimingLamp.Color = [0.00,1.00,0.00];
            special_valve_direct_mode = [app.DirectFlushButton.Value; app.DirectAlt1Button.Value; app.DirectAlt2Button.Value; app.DirectAlt3Button.Value; app.DirectAlt4Button.Value]; %Get Values from direct mode's special valves
            if sum(special_valve_direct_mode) > 0 %If a special valve was selected
                special_valve_direct_mode = find(special_valve_direct_mode==1); %Get position of selected special valve
            else
                special_valve_direct_mode = 0;
            end

            app.reset_all() %Reset single valve buttons

            %%Deactivate unneeded control buttons to prevent confusion
            app.PrimingOntimevalvesSpinner.Editable = 0;
            app.PrimingWaittimeSpinner.Editable = 0;
            app.PrimingLoopsSpinner.Editable = 0;
            app.PrimingPressurepsiSpinner.Editable = 0;
            app.PrimingStartButton.Enable = 0;
            app.PrimingSpecialDropDown.Enable = 0;
            app.PrimingValvedirectionSwitch.Enable = 0;

            app.SynconButton.Enable = 0;
            app.DirectModePanel.Enable = 'off';
            app.SequencePanel.Enable = 'off';
            app.CleaningPanel.Enable = 'off';
            app.AboutPanel.Enable = 'off';





            priming_valves_table_local_hex = app.priming_hex; %Fetch byte code table


            special_valve = str2double(app.PrimingSpecialDropDown.Value); %Fetch selected special valve

            %
            if app.PrimingValvedirectionSwitch.Value == 1 %reverse the byte order in case the valve direction is reversed
                priming_valves_table_local_hex = flip(priming_valves_table_local_hex,2);
            end
            if special_valve >1 %If a special valve was selected...
                priming_valves_table_local_hex_special = priming_valves_table_local_hex; %..copy the code table...
                for i = 1:8
                    priming_valves_table_local_hex_special(3,i) = app.extravalve_table_dec(special_valve + 1); %...and add the command
                end
            end

            timeloop = app.PrimingOntimevalvesSpinner.Value; %Read out valve on time
            waitbetween = app.PrimingWaittimeSpinner.Value; %Read out break time between valves


            app.loop_time = 3;

            %             if timeloop > waitbetween %Check wich time is longer to set waiting time for break command
            %                 app.loop_time = timeloop;
            %             else
            %                 app.loop_time = waitbetween;
            %             end

            loops = app.PrimingLoopsSpinner.Value; %Read number of loops
            app.bulkout(app.valves_off) %Close all valves
            for i_loops = 1:loops
                app.PrimingLoopStandbyLabel.Text = sprintf('Loop %d',i_loops); %Set label
                if breaker == 1
                    break
                end
                for i_valves = 1:8
                    if app.PrimingValvedirectionSwitch.Value == 1
                        valve_label = 9 - i_valves;
                    else
                        valve_label = i_valves;
                    end

                    app.PrimingValveStandbyLabel.Text = sprintf('Valve %d on',valve_label); %Set label
                    app.PrimingTimer.Value = timeloop + 1; %Set residual time for timer
                    app.bulkout(priming_valves_table_local_hex(:,i_valves)) %Open valve





                    if special_valve > 1 %Switch Alt valve on, if selected
                        app.bulkout(priming_valves_table_local_hex_special(:,i_valves))
                    end


                    for i_time = 1:timeloop %Countdown timer with visual feedback
                        try
                            breaker = app.breaker; %Check if break button was pushed
                        catch
                            return
                        end
                        if breaker == 1
                            break
                        end
                        app.PrimingTimer.Value = app.PrimingTimer.Value-1;
                        pause(1)
                    end

                    if breaker == 1
                        break
                    end

                    app.PrimingTimer.Value = 0; %Set timer to 0

                    app.PrimingValveStandbyLabel.Text = sprintf('Valve %d wait',valve_label); %Set label

                    app.bulkout(app.valves_off) %Close valves

                    if ((i_valves < 8) + (i_loops < loops)) > 0 %Apply waittime except for the last valve in last loop
                        if special_valve == 1 %Switch Flush valve on, if selected
                            app.bulkout(app.flush)
                        end

                        try
                            breaker = app.breaker; %Check if break button was pushed
                        catch
                            return
                        end
                        if breaker == 1
                            break
                        end

                        app.PrimingTimer.Value = waitbetween + 1;%Countdown timer with visual feedback
                        for i_time = 1:waitbetween
                            try
                                breaker = app.breaker; %Check if break button was pushed
                            catch
                                return
                            end
                            if breaker == 1
                                break
                            end
                            app.PrimingTimer.Value = app.PrimingTimer.Value-1;
                            pause(1)
                        end
                    end
                    if breaker == 1
                        break
                    end

                    app.PrimingTimer.Value = 0;
                    try
                        breaker = app.breaker; %Check if break button was pushed
                    catch
                        return
                    end
                    if breaker == 1
                        break
                    end

                end

                try
                    breaker = app.breaker; %Check if break button was pushed
                catch
                    return
                end
                if breaker == 1
                    break
                end
            end

            if special_valve == 1 %Close flush valve, if selected or activate
                if breaker == 0
                    app.bulkout(app.flush)
                    app.DirectFlushButton.Value = 1;
                end
            end

            if special_valve_direct_mode > 0 %Reactivate previously state of selected special valves
                if  ~(special_valve == 1) && special_valve_direct_mode == 1 %In case Flush was selected in direct mode but not in priming sequence
                    app.bulkout(app.flush)
                    app.DirectFlushButton.Value = 1;
                elseif special_valve_direct_mode == 2
                    app.DirectAlt1Button.Value = 1;
                elseif special_valve_direct_mode == 3
                    app.DirectAlt2Button.Value = 1;
                elseif special_valve_direct_mode == 4
                    app.DirectAlt3Button.Value = 1;
                elseif special_valve_direct_mode == 5
                    app.DirectAlt4Button.Value = 1;
                end
            end



            %Reactivate commands
            app.loop_time = 0;
            app.PrimingValveStandbyLabel.Text = sprintf('Standby');
            app.PrimingLoopStandbyLabel.Text = sprintf('Standby');
            app.SynconButton.Enable = 1;
            app.DirectModePanel.Enable = 'on';
            app.SequencePanel.Enable = 'on';
            app.CleaningPanel.Enable = 'on';
            app.AboutPanel.Enable = 'on';
            app.PrimingTimer.Value = app.PrimingOntimevalvesSpinner.Value;
            app.PrimingLamp.Color = [0.50,0.50,0.50];
            app.PrimingOntimevalvesSpinner.Editable = 1;
            app.PrimingWaittimeSpinner.Editable = 1;
            app.PrimingLoopsSpinner.Editable = 1;
            app.PrimingPressurepsiSpinner.Editable = 1;
            app.PrimingStartButton.Enable = 1;
            app.PrimingSpecialDropDown.Enable = 1;
            app.PrimingValvedirectionSwitch.Enable = 1;

            beep
        end

        % Value changed function: PrimingOntimevalvesSpinner
        function PrimingOntimevalvesSpinnerValueChanged(app, event)

            app.PrimingTimer.Value = app.PrimingOntimevalvesSpinner.Value; %Set timer
            %       app.priming_hex_calc();
        end

        % Value changed function: PrimingPressurepsiSpinner
        function PrimingPressurepsiSpinnerValueChanged(app, event)
            app.priming_hex_calc() %Refresh byte table for priming when value is changed
        end

        % Value changed function: SynconButton
        function SynconButtonValueChanged(app, event)
            %%(De-)activate the Octaflow II (tm) systems Sync out function
            value = app.SynconButton.Value;
            if value == 1
                app.SynconButton.BackgroundColor = [0.00,0.50,0.00];
                app.SynconButton.Text = 'Sync on';
                app.bulkout(app.sync_on)
            else
                app.SynconButton.BackgroundColor = [0.50,0.00,0.00];
                app.SynconButton.Text = 'Sync off';
                app.bulkout(app.sync_off)

            end
        end

        % Value changed function: DirectFlushButton
        function DirectFlushButtonValueChanged(app, event)
            %%Flush valve properties
            value = app.DirectFlushButton.Value;
            if value == 1
                app.reset_special_valve(1) %Reset Alt buttons
                app.bulkout(app.valves_off)
                app.bulkout(app.flush) %Close flush valve
            else
                app.bulkout(app.valves_off) %open flush valve
            end

        end

        % Value changed function: DirectAlt1Button
        function DirectAlt1ButtonValueChanged(app, event)
            value = app.DirectAlt1Button.Value;
            if value == 1
                app.reset_special_valve(2) %Reset other special valve buttons
            end
        end

        % Value changed function: DirectAlt2Button
        function DirectAlt2ButtonValueChanged(app, event)
            value = app.DirectAlt2Button.Value;
            if value == 1
                app.reset_special_valve(3) %Reset other special valve buttons
            end
        end

        % Value changed function: DirectAlt3Button
        function DirectAlt3ButtonValueChanged(app, event)
            value = app.DirectAlt3Button.Value;
            if value == 1
                app.reset_special_valve(4) %Reset other special valve buttons
            end
        end

        % Value changed function: DirectAlt4Button
        function DirectAlt4ButtonValueChanged(app, event)
            value = app.DirectAlt4Button.Value;
            if value == 1
                app.reset_special_valve(5) %Reset other special valve buttons
            end
        end

        % Button pushed function: SequenceAddstepButton
        function SequenceAddstepButtonPushed(app, event)
            %%Add step to the sequence at selected position with selected
            %%properties

            %%Deactivate unneeded control buttons to prevent confusion
            app.SequenceSeqEditPanel.Enable = 'off';
            app.SequenceAddstepButton.Enable = 0;
            app.SequenceDeleteSpinner.Value = 0;
            app.SequenceDeleteSpinner.Enable = 0;
            app.SequenceDeletestepButton.Enable = 0;
            app.SequenceDeleteallButton.Enable = 0;
            app.SequenceCheckBox.Value = 0;

            new_step = {app.SequenceStepSpinner.Value, app.SequenceValveSpinner.Value, app.SequencePressureSpinner.Value, app.SequenceOnTime.Value, app.SequenceWaitTimeAfter.Value, app.SequenceSpecialDropDown.Value}; %Create new step value array
            step_pos = app.SequenceStepSpinner.Value;

            SeqTable_cache = app.SequenceTable.Data; %Create a local copy of the sequence table

            if isempty(SeqTable_cache) %If the sequence table is empty...
                SeqTable_cache = new_step; %...set SeqTable_cache as new_step...
                app.SequenceStepSpinner.Enable = 1; %... and activate step position and delete step spinner
                app.SequenceDeleteSpinner.Enable = 1;
            elseif step_pos == 1 %If the new step should be placed first in the sequence
                SeqTable_cache = [new_step;SeqTable_cache]; %Combine new step with the present table
            else %Place the step at the selected position
                SeqTable_cache = [SeqTable_cache(1:(step_pos-1),:);new_step; SeqTable_cache((step_pos):end,:)];
            end

            if size(SeqTable_cache,1) > 1 %Refresh the step column values
                for i = 1:size(SeqTable_cache,1)
                    SeqTable_cache{i,1} = i;
                end
            end


            app.SequenceTable.Data = SeqTable_cache; %Set the new SeqTable to the GUI tables property

            %%Prepare the byte out table with on and wait times
            sequence_table_local = {};

            for i = 1:size(SeqTable_cache,1) %for each sequence step
                %%prepare out bytes with valve and pressure information
                valves_hex_local =  app.valves_off_hex;
                valves_hex_local(7:20) = app.valve_table((SeqTable_cache{i,2} + 1),:);
                valves_hex_local(21:24) = app.pressure_table((SeqTable_cache{i,3})+1,:);
                valves_hex_local_byte = app.byte_converter(valves_hex_local);

                %%Prepare special valve information
                if eq(string(SeqTable_cache{i,6}),"Flush")
                    special_valve = 1;
                elseif eq(string(SeqTable_cache{i,6}),"Alt1")
                    special_valve = 2;
                elseif eq(string(SeqTable_cache{i,6}),"Alt2")
                    special_valve = 3;
                elseif eq(string(SeqTable_cache{i,6}),"Alt3")
                    special_valve = 4;
                elseif eq(string(SeqTable_cache{i,6}),"Alt4")
                    special_valve = 5;
                else
                    special_valve = 0;
                end

                %%Create send out information array line and add it to
                %%array
                sequence_table_local_cache = {valves_hex_local_byte, SeqTable_cache{i,4},SeqTable_cache{i,5},special_valve};
                sequence_table_local = [sequence_table_local;sequence_table_local_cache];
            end

            app.sequence_table = sequence_table_local; %save local array to property

            %%Modify step and delete spinner based on new number of steps
            %%in sequence
            app.SequenceStepSpinner.Limits = [1, (size(SeqTable_cache,1)+1)];
            app.SequenceStepSpinner.Value = (size(SeqTable_cache,1)+1);
            app.SequenceDeleteSpinner.Limits = [0, size(SeqTable_cache,1)];


            %%Enable control buttons
            app.SequenceAddstepButton.Enable = 1;
            app.SequenceSeqEditPanel.Enable = 'on';
            app.SequenceDeleteSpinner.Enable = 1;
            app.SequenceStartsequenceButton.Enable = 1;
        end

        % Value changed function: SequenceDeleteSpinner
        function SequenceDeleteSpinnerValueChanged(app, event)
            %%If spinner value is zero, delete button is disabled. Will
            %%prevent accidental deletion of steps
            if app.SequenceDeleteSpinner.Value > 0
                app.SequenceDeletestepButton.Enable = 1;
            else
                app.SequenceDeletestepButton.Enable = 0;
            end

        end

        % Button pushed function: SequenceDeletestepButton
        function SequenceDeletestepButtonPushed(app, event)
            %%Delets selected step

            %%Deactivate unneeded control buttons to prevent confusion
            app.SequenceAddstepButton.Enable = 0;
            app.SequenceDeletestepButton.Enable = 0;
            app.SequenceDeleteallButton.Enable = 0;
            app.SequenceCheckBox.Value = 0;
            SeqTable_cache = app.SequenceTable.Data;
            sequence_table_local = app.sequence_table;

            %%Delete selected step from the table and the sequence_table
            %%property
            delete_step = app.SequenceDeleteSpinner.Value;
            SeqTable_cache(delete_step,:) = [];
            sequence_table_local(delete_step,:) = [];



            if size(SeqTable_cache,1) > 0 %Refresh the step column values, if steps are left in the table
                for i = 1:size(SeqTable_cache,1)
                    SeqTable_cache{i,1} = i;
                end

                %%Modify step and delete spinner based on new number of steps
                %%in sequence
                app.SequenceStepSpinner.Limits = [1, (size(SeqTable_cache,1)+1)];
                app.SequenceStepSpinner.Value = (size(SeqTable_cache,1)+1);
                app.SequenceDeleteSpinner.Limits = [0, size(SeqTable_cache,1)];




            else %if the last step was deleted from the table
                %%Modify step and delete spinner
                app.SequenceStepSpinner.Limits = [1, 2];
                app.SequenceStepSpinner.Value = 1;
                app.SequenceDeleteSpinner.Limits = [0, 1];

                %%Disable start button, step and delete spinner
                app.SequenceStartsequenceButton.Enable = 0;
                app.SequenceStepSpinner.Enable = 0;
                app.SequenceDeleteSpinner.Enable = 0;


            end

            %%Set changes to properties
            app.SequenceTable.Data = SeqTable_cache;
            app.sequence_table = sequence_table_local;


            app.SequenceDeleteSpinner.Value = 0; %Set delete spinner to 0

            %Reactivate control
            app.SequenceAddstepButton.Enable = 1;




        end

        % Button pushed function: SequenceStartsequenceButton
        function SequenceStartsequenceButtonPushed(app, event)
            %%Starts valve sequence based on table

            app.breaker = 0;
            breaker = 0;
            app.SequenceLamp.Color = [0.00,1.00,0.00];

            %%Deactivate unneeded control buttons to prevent confusion
            app.SynconButton.Enable = 0;
            app.DirectModePanel.Enable = 'off';
            app.PrimingPanel.Enable = 'off';
            app.CleaningPanel.Enable = 'off';
            app.AboutPanel.Enable = 'off';
            app.SequenceSeqEditPanel.Enable = 'off';
            app.SequenceDeleteSpinner.Enable = 0;
            app.SequenceAddstepButton.Enable = 0;
            app.SequenceDeleteSpinner.Value = 0;
            app.SequenceDeletestepButton.Enable = 0;
            app.SequenceStartsequenceButton.Enable = 0;
            app.SequenceDeleteallButton.Enable = 0;
            app.SequenceCheckBox.Value = 0;
            app.SequenceCheckBox.Enable = 0;




            sequence_table_local = app.sequence_table; %Create a local copy of the sequence table
            app.loop_time = 3;  %Set wait time for break conditions

            for i = 1: size(sequence_table_local,1) %Send out the commands stepwise

                %%Fetch the data
                hexout_byte = sequence_table_local{i,1};
                ontime = sequence_table_local{i,2};
                waittime = sequence_table_local{i,3};
                specialvalve = sequence_table_local{i,4};

                %%Determine longest pause time for break wait time

                %                 if ontime > waittime
                %                     app.loop_time = ontime;
                %                 else
                %                     app.loop_time = waittime;
                %                 end
                %%Set number of loops and residual time for break
                %%conditions
                full_loops_on = floor(ontime / 2); %Calculate full 5 s loops for break option
                rest_time_on = rem(ontime, 2); %Calculate rest time for break option
                full_loops_wait = floor(waittime / 2); %Calculate full 2 s loops for break option
                rest_time_wait = rem(waittime, 2); %Calculate rest time for break option


                %%Prepare send out byte in case an Alt valve was selected
                if specialvalve > 1
                    hexout_special_byte = hexout_byte;
                    if specialvalve == 2
                        hexout_special_byte(3) = 32;
                    elseif specialvalve == 3
                        hexout_special_byte(3) = 64;
                    elseif specialvalve == 4
                        hexout_special_byte(3) = 1;
                    elseif specialvalve == 5
                        hexout_special_byte(3) = 2;
                    end
                end

                app.bulkout(app.valves_off) %switch off all valves
                app.bulkout(hexout_byte) %Activate valve

                if specialvalve > 1
                    app.bulkout(hexout_special_byte) %Activate special valve
                end
                app.SequenceStepStandbyLabel.Text = sprintf('Step %d on',i); %Set label

                for i = 1:full_loops_on
                    pause(2)
                    try
                        breaker = app.breaker; %Check if break button was pushed
                    catch
                        breaker = 1;
                        break
                    end
                    if breaker == 1
                        break
                    end
                end
                if breaker == 0
                    pause(rest_time_on) %Wait for rest of the selected open time
                end






                %Break loop if break button was pushed
                try
                    breaker = app.breaker; %Check if break button was pushed
                catch
                    return
                end
                if breaker == 1
                    break
                end


                app.bulkout(app.valves_off) %switch valves off

                if specialvalve == 1 %switch flush valve off, if selected
                    app.bulkout(app.flush);
                end


                app.SequenceStepStandbyLabel.Text = sprintf('Step %d wait',i); %Set label

                for i = 1:full_loops_wait
                    pause(2)
                    try
                        breaker = app.breaker; %Check if break button was pushed
                    catch
                        return
                    end
                    if breaker == 1
                        break
                    end
                end
                if breaker == 0
                    pause(rest_time_wait) %Wait for rest of the selected open time
                end





                %Break loop if break button was pushed
                try
                    breaker = app.breaker; %Check if break button was pushed
                catch
                    return
                end
                if breaker == 1
                    break
                end


            end

            app.bulkout(app.valves_off) %switch valves off

            if app.SynconButton.Value == 1 %If Sync is on, necessary to send out TTL pulse when last valve was closed
                app.bulkout(app.sync_valve_off);
                app.bulkout(app.valves_off)
            end

            %%Reactivate commands
            app.DirectFlushButton.Value = 0;
            app.SequenceLamp.Color = [0.50,0.50,0.50];
            app.SynconButton.Enable = 1;
            app.DirectModePanel.Enable = 'on';
            app.PrimingPanel.Enable = 'on';
            app.CleaningPanel.Enable = 'on';
            app.AboutPanel.Enable = 'on';

            app.loop_time = 0;
            app.SequenceSeqEditPanel.Enable = 'on';
            app.SequenceDeleteSpinner.Enable = 1;
            app.SequenceAddstepButton.Enable = 1;
            app.SequenceCheckBox.Enable = 1;
            app.SequenceStartsequenceButton.Enable = 1;
            app.SequenceStepStandbyLabel.Text = sprintf('Standby');

            beep
        end

        % Value changed function: SequenceCheckBox
        function SequenceCheckBoxValueChanged(app, event)
            %%Enables/ disables delete all button
            if ((app.SequenceCheckBox.Value == 1) + (isempty(app.SequenceTable.Data)) == 2) %if box was checked and no deletable data is present...
                app.SequenceCheckBox.Value = 0; %...uncheck box
            elseif ((app.SequenceCheckBox.Value == 1) + ((~(isempty(app.SequenceTable.Data))) * 0.5) == 1.5) %If box was checked and deletable data is present...
                app.SequenceDeleteallButton.Enable = 1; %...enable delete all button
            else
                app.SequenceDeleteallButton.Enable = 0; %disables delete all button

            end
        end

        % Button pushed function: SequenceDeleteallButton
        function SequenceDeleteallButtonPushed(app, event)
            %%Delete complete sequence table

            %%Deactivate unneeded control buttons to prevent confusion
            app.SequenceAddstepButton.Enable = 0;
            app.SequenceDeletestepButton.Enable = 0;
            app.SequenceDeleteallButton.Enable = 0;
            app.SequenceCheckBox.Value = 0;
            app.SequenceStartsequenceButton.Enable = 0;


            app.SequenceTable.Data = {}; %Delete sequence table data

            %%Modify step and delete spinner
            app.SequenceStepSpinner.Limits = [1, 2];
            app.SequenceStepSpinner.Value = 1;
            app.SequenceDeleteSpinner.Limits = [0, 1];

            %%Disable start button, step and delete spinner
            app.SequenceStartsequenceButton.Enable = 0;
            app.SequenceStepSpinner.Enable = 0;
            app.SequenceDeleteSpinner.Enable = 0;

            %Enable control buttons
            app.SequenceAddstepButton.Enable = 1;

        end

        % Value changed function: CleaningCheckBox
        function CleaningCheckBoxValueChanged(app, event)
            if app.CleaningCheckBox.Value == 1
                app.CleaningQuickflushButton.Enable = 1;
            else
                app.CleaningQuickflushButton.Enable = 0;
            end

        end

        % Button pushed function: CleaningStartButton
        function CleaningStartButtonPushed(app, event)
            %%Opens all regular valves simultaneously for set time with set
            %%pressure

            app.breaker = 0; %Set break property
            app.reset_all()
            app.loop_time = 5; %Set break wait time


            app.CleaningLamp.Color = [0.00,1.00,0.00];

            %%Deactivate unneeded control buttons to prevent confusion
            app.CleaningTimeSpinner.Editable = 0;
            app.CleaningpressurepsiSpinner.Editable = 0;
            app.CleaningStartButton.Enable = 0;
            app.SynconButton.Enable = 0;
            app.CleaningQuickflushButton.Enable = 0;
            app.CleaningCheckBox.Enable = 0;
            app.CleaningCheckBox.Value = 0;
            app.DirectModePanel.Enable = 'off';
            app.SequencePanel.Enable = 'off';
            app.PrimingPanel.Enable = 'off';
            app.AboutPanel.Enable = 'off';



            %%Prepare send out bytes
            cleaning_off = '02000000000000C80A000C0000000027';
            cleaning_off_hex = app.byte_converter(cleaning_off);
            cleaning_on = '020000FF000000C80A44E80300000027';
            cleaning_on(21:24) = app.pressure_table((app.CleaningpressurepsiSpinner.Value)+1,:);
            cleaning_on_hex = app.byte_converter(cleaning_on);



            app.bulkout(cleaning_on_hex) %open valves


            app.CleaningTimer.Value = app.CleaningTimeSpinner.Value;
            timer_down = app.CleaningTimeSpinner.Value;
            for i = 1:(12*app.CleaningTimeSpinner.Value) %Refresh residual time timer every 5s
                pause(5)
                app.CleaningTimer.Value = (timer_down -(i/12));
                try
                    breaker = app.breaker; %Check if break button was pushed
                catch
                    return
                end
                if breaker == 1
                    break
                end
            end

            app.bulkout(cleaning_off_hex) %close valves

            %Reactivate control panels
            app.CleaningLamp.Color = [0.50,0.50,0.50];
            app.CleaningTimeSpinner.Editable = 1;
            app.CleaningpressurepsiSpinner.Editable = 1;
            app.CleaningStartButton.Enable = 1;
            app.CleaningCheckBox.Enable = 1;
            app.SynconButton.Enable = 1;
            app.DirectModePanel.Enable = 'on';
            app.SequencePanel.Enable = 'on';
            app.PrimingPanel.Enable = 'on';
            app.AboutPanel.Enable = 'on';
            app.CleaningTimer.Value = app.CleaningTimeSpinner.Value;
            beep





        end

        % Button pushed function: CleaningQuickflushButton
        function CleaningQuickflushButtonPushed(app, event)
            app.breaker = 0;
            %%Opens all regular valves simultaneously for 30 s with 30 psi
            app.CleaningQuickflushButton.Enable = 0;
            app.CleaningCheckBox.Enable = 0;
            app.reset_all()



            app.CleaningQuickflushButton.BackgroundColor = [0.00,1.00,0.00];


            %%Deactivate unneeded control buttons to prevent confusion
            app.CleaningTimeSpinner.Editable = 0;
            app.CleaningpressurepsiSpinner.Editable = 0;
            app.CleaningStartButton.Enable = 0;
            app.SynconButton.Enable = 0;

            app.DirectModePanel.Enable = 'off';
            app.SequencePanel.Enable = 'off';
            app.PrimingPanel.Enable = 'off';
            app.AboutPanel.Enable = 'off';



            %%Prepare send out bytes
            cleaning_off = '02000000000000C80A000C0000000027';
            cleaning_off_hex = app.byte_converter(cleaning_off);
            cleaning_on = '020000FF000000C80A44E80300000027';
            cleaning_on_hex = app.byte_converter(cleaning_on);


            app.CleaningTimer.Value = 15/60;
            app.bulkout(cleaning_on_hex) %open valves
            for i = 1:15
                pause(1)
                app.CleaningTimer.Value = (15 - (i))/60;
                try
                    breaker = app.breaker; %Check if break button was pushed
                catch
                    return
                end
                if breaker == 1
                    break
                end
            end

            app.bulkout(cleaning_off_hex) %close valves

            %Reactivate control panels

            app.CleaningTimeSpinner.Editable = 1;
            app.CleaningpressurepsiSpinner.Editable = 1;
            app.CleaningStartButton.Enable = 1;
            app.SynconButton.Enable = 1;
            app.CleaningQuickflushButton.Enable = 1;
            app.CleaningCheckBox.Enable = 1;
            app.DirectModePanel.Enable = 'on';
            app.SequencePanel.Enable = 'on';
            app.PrimingPanel.Enable = 'on';
            app.AboutPanel.Enable = 'on';
            app.CleaningQuickflushButton.BackgroundColor = [0.96,0.96,0.96];
            app.CleaningTimer.Value = app.CleaningTimeSpinner.Value;
            beep
        end

        % Value changed function: CleaningTimeSpinner
        function CleaningTimeSpinnerValueChanged(app, event)
            app.CleaningTimer.Value = app.CleaningTimeSpinner.Value;

        end

        % Button pushed function: ManualButton
        function ManualButtonPushed(app, event)
            winopen('OctaflowControlApp_Manual.pdf')
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create OctaflowIIControlAppUIFigure and hide until all components are created
            app.OctaflowIIControlAppUIFigure = uifigure('Visible', 'off');
            app.OctaflowIIControlAppUIFigure.Position = [100 100 640 508];
            app.OctaflowIIControlAppUIFigure.Name = 'Octaflow II Control App';
            app.OctaflowIIControlAppUIFigure.Resize = 'off';
            app.OctaflowIIControlAppUIFigure.CloseRequestFcn = createCallbackFcn(app, @OctaflowIIControlAppUIFigureCloseRequest, true);

            % Create StartTextArea_1
            app.StartTextArea_1 = uitextarea(app.OctaflowIIControlAppUIFigure);
            app.StartTextArea_1.Editable = 'off';
            app.StartTextArea_1.Visible = 'off';
            app.StartTextArea_1.Position = [471 27 150 50];
            app.StartTextArea_1.Value = {'Spike Voltage:    18'; 'Hold Voltage:      12'; 'Spike Time (ms): 5'};

            % Create BreakButton
            app.BreakButton = uibutton(app.OctaflowIIControlAppUIFigure, 'push');
            app.BreakButton.ButtonPushedFcn = createCallbackFcn(app, @BreakButtonPushed, true);
            app.BreakButton.BackgroundColor = [1 0 0];
            app.BreakButton.FontWeight = 'bold';
            app.BreakButton.FontColor = [1 1 1];
            app.BreakButton.Visible = 'off';
            app.BreakButton.Position = [535 484 100 22];
            app.BreakButton.Text = 'Break';

            % Create SynconButton
            app.SynconButton = uibutton(app.OctaflowIIControlAppUIFigure, 'state');
            app.SynconButton.ValueChangedFcn = createCallbackFcn(app, @SynconButtonValueChanged, true);
            app.SynconButton.Visible = 'off';
            app.SynconButton.Text = 'Sync on';
            app.SynconButton.BackgroundColor = [0 0.502 0];
            app.SynconButton.FontWeight = 'bold';
            app.SynconButton.FontColor = [1 1 1];
            app.SynconButton.Position = [10 484 100 22];
            app.SynconButton.Value = true;

            % Create StartAppButton
            app.StartAppButton = uibutton(app.OctaflowIIControlAppUIFigure, 'push');
            app.StartAppButton.ButtonPushedFcn = createCallbackFcn(app, @StartAppButtonPushed, true);
            app.StartAppButton.FontSize = 20;
            app.StartAppButton.Enable = 'off';
            app.StartAppButton.Position = [261 102 100 31];
            app.StartAppButton.Text = 'Start';

            % Create StartTextArea_2
            app.StartTextArea_2 = uitextarea(app.OctaflowIIControlAppUIFigure);
            app.StartTextArea_2.Editable = 'off';
            app.StartTextArea_2.HorizontalAlignment = 'center';
            app.StartTextArea_2.FontSize = 20;
            app.StartTextArea_2.Position = [28 188 593 253];
            app.StartTextArea_2.Value = {'Octaflow II Control App was designed with MATLAB R2021b'; 'Cyusb.sys driver (1.2.3.14) must be installed '; ''; 'This is not an official control app for the Octaflow II™ system'; 'Use at your own risk'; ''; 'If connection with the Octaflow II™ system is lost when valves are open, app freezes and must be force closed'; ''};

            % Create StartSwitchonOctaflowIIsystemLabel
            app.StartSwitchonOctaflowIIsystemLabel = uilabel(app.OctaflowIIControlAppUIFigure);
            app.StartSwitchonOctaflowIIsystemLabel.BackgroundColor = [0.5882 0 0];
            app.StartSwitchonOctaflowIIsystemLabel.HorizontalAlignment = 'center';
            app.StartSwitchonOctaflowIIsystemLabel.FontSize = 20;
            app.StartSwitchonOctaflowIIsystemLabel.FontColor = [1 1 1];
            app.StartSwitchonOctaflowIIsystemLabel.Visible = 'off';
            app.StartSwitchonOctaflowIIsystemLabel.Position = [163 150 306 24];
            app.StartSwitchonOctaflowIIsystemLabel.Text = 'Switch on Octaflow II (tm) system';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.OctaflowIIControlAppUIFigure);
            app.TabGroup.Visible = 'off';
            app.TabGroup.Position = [1 112 640 367];

            % Create DirectModeTab
            app.DirectModeTab = uitab(app.TabGroup);
            app.DirectModeTab.Title = 'Direct Mode';
            app.DirectModeTab.BackgroundColor = [1 1 1];

            % Create DirectModePanel
            app.DirectModePanel = uipanel(app.DirectModeTab);
            app.DirectModePanel.Position = [2 2 638 340];

            % Create Valve1Button
            app.Valve1Button = uibutton(app.DirectModePanel, 'state');
            app.Valve1Button.ValueChangedFcn = createCallbackFcn(app, @Valve1ButtonValueChanged, true);
            app.Valve1Button.Text = 'Valve 1';
            app.Valve1Button.BackgroundColor = [0.8 0.8 0.8];
            app.Valve1Button.Position = [15 132 63 22];

            % Create DirectValve2Button
            app.DirectValve2Button = uibutton(app.DirectModePanel, 'state');
            app.DirectValve2Button.ValueChangedFcn = createCallbackFcn(app, @DirectValve2ButtonValueChanged, true);
            app.DirectValve2Button.Text = 'Valve 2';
            app.DirectValve2Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectValve2Button.Position = [93 132 63 22];

            % Create DirectValve3Button
            app.DirectValve3Button = uibutton(app.DirectModePanel, 'state');
            app.DirectValve3Button.ValueChangedFcn = createCallbackFcn(app, @DirectValve3ButtonValueChanged, true);
            app.DirectValve3Button.Text = 'Valve 3';
            app.DirectValve3Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectValve3Button.Position = [172 132 63 22];

            % Create DirectValve4Button
            app.DirectValve4Button = uibutton(app.DirectModePanel, 'state');
            app.DirectValve4Button.ValueChangedFcn = createCallbackFcn(app, @DirectValve4ButtonValueChanged, true);
            app.DirectValve4Button.Text = 'Valve 4';
            app.DirectValve4Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectValve4Button.Position = [248 132 63 22];

            % Create DirectValve5Button
            app.DirectValve5Button = uibutton(app.DirectModePanel, 'state');
            app.DirectValve5Button.ValueChangedFcn = createCallbackFcn(app, @DirectValve5ButtonValueChanged, true);
            app.DirectValve5Button.Text = 'Valve 5';
            app.DirectValve5Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectValve5Button.Position = [326 132 63 22];

            % Create DirectValve6Button
            app.DirectValve6Button = uibutton(app.DirectModePanel, 'state');
            app.DirectValve6Button.ValueChangedFcn = createCallbackFcn(app, @DirectValve6ButtonValueChanged, true);
            app.DirectValve6Button.Text = 'Valve 6';
            app.DirectValve6Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectValve6Button.Position = [404 132 63 22];

            % Create Valve7Button
            app.Valve7Button = uibutton(app.DirectModePanel, 'state');
            app.Valve7Button.ValueChangedFcn = createCallbackFcn(app, @DirectValve7ButtonValueChanged, true);
            app.Valve7Button.Text = 'Valve 7';
            app.Valve7Button.BackgroundColor = [0.8 0.8 0.8];
            app.Valve7Button.Position = [481 132 63 22];

            % Create DirectValve8Button
            app.DirectValve8Button = uibutton(app.DirectModePanel, 'state');
            app.DirectValve8Button.ValueChangedFcn = createCallbackFcn(app, @DirectValve8ButtonValueChanged, true);
            app.DirectValve8Button.Text = 'Valve 8';
            app.DirectValve8Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectValve8Button.Position = [558 132 63 22];

            % Create DirectFlushButton
            app.DirectFlushButton = uibutton(app.DirectModePanel, 'state');
            app.DirectFlushButton.ValueChangedFcn = createCallbackFcn(app, @DirectFlushButtonValueChanged, true);
            app.DirectFlushButton.Text = 'Flush';
            app.DirectFlushButton.BackgroundColor = [0.8 0.8 0.8];
            app.DirectFlushButton.Position = [157 308 74 22];

            % Create DirectAlt1Button
            app.DirectAlt1Button = uibutton(app.DirectModePanel, 'state');
            app.DirectAlt1Button.ValueChangedFcn = createCallbackFcn(app, @DirectAlt1ButtonValueChanged, true);
            app.DirectAlt1Button.Text = 'Alt 1';
            app.DirectAlt1Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectAlt1Button.Position = [239 308 74 22];

            % Create DirectAlt2Button
            app.DirectAlt2Button = uibutton(app.DirectModePanel, 'state');
            app.DirectAlt2Button.ValueChangedFcn = createCallbackFcn(app, @DirectAlt2ButtonValueChanged, true);
            app.DirectAlt2Button.Text = 'Alt 2';
            app.DirectAlt2Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectAlt2Button.Position = [323 308 74 22];

            % Create DirectAlt3Button
            app.DirectAlt3Button = uibutton(app.DirectModePanel, 'state');
            app.DirectAlt3Button.ValueChangedFcn = createCallbackFcn(app, @DirectAlt3ButtonValueChanged, true);
            app.DirectAlt3Button.Text = 'Alt 3';
            app.DirectAlt3Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectAlt3Button.Position = [403 308 74 22];

            % Create DirectAlt4Button
            app.DirectAlt4Button = uibutton(app.DirectModePanel, 'state');
            app.DirectAlt4Button.ValueChangedFcn = createCallbackFcn(app, @DirectAlt4ButtonValueChanged, true);
            app.DirectAlt4Button.Text = 'Alt 4';
            app.DirectAlt4Button.BackgroundColor = [0.8 0.8 0.8];
            app.DirectAlt4Button.Position = [482 308 74 22];

            % Create DirectOntimeLabel
            app.DirectOntimeLabel = uilabel(app.DirectModePanel);
            app.DirectOntimeLabel.FontSize = 20;
            app.DirectOntimeLabel.FontWeight = 'bold';
            app.DirectOntimeLabel.Position = [254 167 134 24];
            app.DirectOntimeLabel.Text = 'On time';

            % Create pressurepsiSpinner_2Label
            app.pressurepsiSpinner_2Label = uilabel(app.DirectModePanel);
            app.pressurepsiSpinner_2Label.HorizontalAlignment = 'right';
            app.pressurepsiSpinner_2Label.Position = [14 251 79 22];
            app.pressurepsiSpinner_2Label.Text = 'pressure (psi)';

            % Create pressurepsiSpinner_2
            app.pressurepsiSpinner_2 = uispinner(app.DirectModePanel);
            app.pressurepsiSpinner_2.Limits = [0 30];
            app.pressurepsiSpinner_2.Position = [96 251 49 22];
            app.pressurepsiSpinner_2.Value = 10;

            % Create OntimesSpinnerLabel
            app.OntimesSpinnerLabel = uilabel(app.DirectModePanel);
            app.OntimesSpinnerLabel.HorizontalAlignment = 'right';
            app.OntimesSpinnerLabel.Visible = 'off';
            app.OntimesSpinnerLabel.Position = [168 200 65 22];
            app.OntimesSpinnerLabel.Text = 'On time (s)';

            % Create DirectOntimesSpinner
            app.DirectOntimesSpinner = uispinner(app.DirectModePanel);
            app.DirectOntimesSpinner.Limits = [1 300];
            app.DirectOntimesSpinner.Visible = 'off';
            app.DirectOntimesSpinner.Position = [236 200 60 22];
            app.DirectOntimesSpinner.Value = 1;

            % Create closevalveSwitchLabel
            app.closevalveSwitchLabel = uilabel(app.DirectModePanel);
            app.closevalveSwitchLabel.HorizontalAlignment = 'center';
            app.closevalveSwitchLabel.Position = [66 219 65 22];
            app.closevalveSwitchLabel.Text = 'close valve';

            % Create DirectclosevalveSwitch
            app.DirectclosevalveSwitch = uiswitch(app.DirectModePanel, 'slider');
            app.DirectclosevalveSwitch.Items = {'manually', 'timer'};
            app.DirectclosevalveSwitch.ItemsData = [0 1];
            app.DirectclosevalveSwitch.ValueChangedFcn = createCallbackFcn(app, @DirectclosevalveSwitchValueChanged, true);
            app.DirectclosevalveSwitch.Position = [75 200 45 20];
            app.DirectclosevalveSwitch.Value = 0;

            % Create DirectTextArea_1
            app.DirectTextArea_1 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_1.Position = [9 41 73 86];

            % Create DirectTextArea_2
            app.DirectTextArea_2 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_2.Position = [88 41 73 86];

            % Create DirectTextArea_3
            app.DirectTextArea_3 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_3.Position = [166 41 73 86];

            % Create DirectTextArea_4
            app.DirectTextArea_4 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_4.Position = [243 41 73 86];

            % Create DirectTextArea_5
            app.DirectTextArea_5 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_5.Position = [321 41 73 86];

            % Create DirectTextArea_6
            app.DirectTextArea_6 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_6.Position = [399 41 73 86];

            % Create DirectTextArea_7
            app.DirectTextArea_7 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_7.Position = [476 41 73 86];

            % Create DirectTextArea_8
            app.DirectTextArea_8 = uitextarea(app.DirectModePanel);
            app.DirectTextArea_8.Position = [553 41 73 86];

            % Create SequenceTab
            app.SequenceTab = uitab(app.TabGroup);
            app.SequenceTab.Title = 'Sequence';

            % Create SequencePanel
            app.SequencePanel = uipanel(app.SequenceTab);
            app.SequencePanel.Position = [2 2 638 340];

            % Create SequenceTable
            app.SequenceTable = uitable(app.SequencePanel);
            app.SequenceTable.ColumnName = {'Step'; 'Valve'; 'Pressure (psi)'; 'Opening time (s)'; 'Wait time after (s)'; 'Special valve'};
            app.SequenceTable.ColumnWidth = {40, 50, 100, 120, 120, 90};
            app.SequenceTable.RowName = {};
            app.SequenceTable.Position = [32 114 522 185];

            % Create SequenceAddstepButton
            app.SequenceAddstepButton = uibutton(app.SequencePanel, 'push');
            app.SequenceAddstepButton.ButtonPushedFcn = createCallbackFcn(app, @SequenceAddstepButtonPushed, true);
            app.SequenceAddstepButton.Position = [559 306 65 22];
            app.SequenceAddstepButton.Text = 'Add step';

            % Create SequenceStartsequenceButton
            app.SequenceStartsequenceButton = uibutton(app.SequencePanel, 'push');
            app.SequenceStartsequenceButton.ButtonPushedFcn = createCallbackFcn(app, @SequenceStartsequenceButtonPushed, true);
            app.SequenceStartsequenceButton.FontSize = 16;
            app.SequenceStartsequenceButton.FontWeight = 'bold';
            app.SequenceStartsequenceButton.Enable = 'off';
            app.SequenceStartsequenceButton.Position = [18 59 130 26];
            app.SequenceStartsequenceButton.Text = 'Start sequence';

            % Create SequenceStepStandbyLabel
            app.SequenceStepStandbyLabel = uilabel(app.SequencePanel);
            app.SequenceStepStandbyLabel.BackgroundColor = [1 1 1];
            app.SequenceStepStandbyLabel.HorizontalAlignment = 'center';
            app.SequenceStepStandbyLabel.FontSize = 20;
            app.SequenceStepStandbyLabel.FontWeight = 'bold';
            app.SequenceStepStandbyLabel.Position = [184 49 163 45];
            app.SequenceStepStandbyLabel.Text = 'Step: Standby';

            % Create SequenceDeleteSpinner
            app.SequenceDeleteSpinner = uispinner(app.SequencePanel);
            app.SequenceDeleteSpinner.Limits = [0 1];
            app.SequenceDeleteSpinner.ValueChangedFcn = createCallbackFcn(app, @SequenceDeleteSpinnerValueChanged, true);
            app.SequenceDeleteSpinner.Enable = 'off';
            app.SequenceDeleteSpinner.Position = [564 83 51 22];

            % Create SequenceDeletestepButton
            app.SequenceDeletestepButton = uibutton(app.SequencePanel, 'push');
            app.SequenceDeletestepButton.ButtonPushedFcn = createCallbackFcn(app, @SequenceDeletestepButtonPushed, true);
            app.SequenceDeletestepButton.Enable = 'off';
            app.SequenceDeletestepButton.Position = [457 83 100 22];
            app.SequenceDeletestepButton.Text = 'Delete step';

            % Create SequenceSeqEditPanel
            app.SequenceSeqEditPanel = uipanel(app.SequencePanel);
            app.SequenceSeqEditPanel.Position = [32 303 522 30];

            % Create SequenceStepSpinner
            app.SequenceStepSpinner = uispinner(app.SequenceSeqEditPanel);
            app.SequenceStepSpinner.Limits = [1 2];
            app.SequenceStepSpinner.Enable = 'off';
            app.SequenceStepSpinner.Position = [2 4 38 22];
            app.SequenceStepSpinner.Value = 1;

            % Create SequenceValveSpinner
            app.SequenceValveSpinner = uispinner(app.SequenceSeqEditPanel);
            app.SequenceValveSpinner.Limits = [1 8];
            app.SequenceValveSpinner.Position = [47 4 46 22];
            app.SequenceValveSpinner.Value = 1;

            % Create SequencePressureSpinner
            app.SequencePressureSpinner = uispinner(app.SequenceSeqEditPanel);
            app.SequencePressureSpinner.Limits = [0 30];
            app.SequencePressureSpinner.Position = [121 4 46 22];
            app.SequencePressureSpinner.Value = 10;

            % Create SequenceWaitTimeAfter
            app.SequenceWaitTimeAfter = uieditfield(app.SequenceSeqEditPanel, 'numeric');
            app.SequenceWaitTimeAfter.Limits = [0 Inf];
            app.SequenceWaitTimeAfter.Position = [329 3 53 22];

            % Create SequenceOnTime
            app.SequenceOnTime = uieditfield(app.SequenceSeqEditPanel, 'numeric');
            app.SequenceOnTime.Limits = [1 Inf];
            app.SequenceOnTime.Position = [219 3 53 22];
            app.SequenceOnTime.Value = 10;

            % Create SequenceSpecialDropDown
            app.SequenceSpecialDropDown = uidropdown(app.SequenceSeqEditPanel);
            app.SequenceSpecialDropDown.Items = {'None', 'Flush', 'Alt1', 'Alt2', 'Alt3', 'Alt4'};
            app.SequenceSpecialDropDown.Position = [436 4 68 22];
            app.SequenceSpecialDropDown.Value = 'None';

            % Create SequenceLamp
            app.SequenceLamp = uilamp(app.SequencePanel);
            app.SequenceLamp.Position = [152 62 20 20];
            app.SequenceLamp.Color = [0.502 0.502 0.502];

            % Create SequenceDeleteallButton
            app.SequenceDeleteallButton = uibutton(app.SequencePanel, 'push');
            app.SequenceDeleteallButton.ButtonPushedFcn = createCallbackFcn(app, @SequenceDeleteallButtonPushed, true);
            app.SequenceDeleteallButton.Enable = 'off';
            app.SequenceDeleteallButton.Position = [457 60 100 22];
            app.SequenceDeleteallButton.Text = 'Delete all';

            % Create SequenceCheckBox
            app.SequenceCheckBox = uicheckbox(app.SequencePanel);
            app.SequenceCheckBox.ValueChangedFcn = createCallbackFcn(app, @SequenceCheckBoxValueChanged, true);
            app.SequenceCheckBox.Text = '';
            app.SequenceCheckBox.Position = [565 60 25 22];

            % Create PrimingTab
            app.PrimingTab = uitab(app.TabGroup);
            app.PrimingTab.Title = 'Priming';
            app.PrimingTab.BackgroundColor = [0.502 0.502 0.502];

            % Create PrimingPanel
            app.PrimingPanel = uipanel(app.PrimingTab);
            app.PrimingPanel.ForegroundColor = [1 1 1];
            app.PrimingPanel.BackgroundColor = [0.502 0.502 0.502];
            app.PrimingPanel.Position = [1 2 639 340];

            % Create LoopsSpinnerLabel
            app.LoopsSpinnerLabel = uilabel(app.PrimingPanel);
            app.LoopsSpinnerLabel.HorizontalAlignment = 'right';
            app.LoopsSpinnerLabel.FontColor = [1 1 1];
            app.LoopsSpinnerLabel.Position = [133 302 38 22];
            app.LoopsSpinnerLabel.Text = 'Loops';

            % Create PrimingLoopsSpinner
            app.PrimingLoopsSpinner = uispinner(app.PrimingPanel);
            app.PrimingLoopsSpinner.Limits = [1 20];
            app.PrimingLoopsSpinner.Position = [174 302 49 22];
            app.PrimingLoopsSpinner.Value = 5;

            % Create pressurepsiSpinner_3Label
            app.pressurepsiSpinner_3Label = uilabel(app.PrimingPanel);
            app.pressurepsiSpinner_3Label.HorizontalAlignment = 'right';
            app.pressurepsiSpinner_3Label.FontColor = [1 1 1];
            app.pressurepsiSpinner_3Label.Position = [92 256 79 22];
            app.pressurepsiSpinner_3Label.Text = 'pressure (psi)';

            % Create PrimingPressurepsiSpinner
            app.PrimingPressurepsiSpinner = uispinner(app.PrimingPanel);
            app.PrimingPressurepsiSpinner.Limits = [0 30];
            app.PrimingPressurepsiSpinner.ValueChangedFcn = createCallbackFcn(app, @PrimingPressurepsiSpinnerValueChanged, true);
            app.PrimingPressurepsiSpinner.Position = [174 256 49 22];
            app.PrimingPressurepsiSpinner.Value = 20;

            % Create PrimingStartButton
            app.PrimingStartButton = uibutton(app.PrimingPanel, 'push');
            app.PrimingStartButton.ButtonPushedFcn = createCallbackFcn(app, @PrimingStartButtonPushed, true);
            app.PrimingStartButton.Position = [38 157 100 22];
            app.PrimingStartButton.Text = 'Start';

            % Create openingtimevalvesLabel
            app.openingtimevalvesLabel = uilabel(app.PrimingPanel);
            app.openingtimevalvesLabel.HorizontalAlignment = 'right';
            app.openingtimevalvesLabel.FontColor = [1 1 1];
            app.openingtimevalvesLabel.Position = [48 279 123 22];
            app.openingtimevalvesLabel.Text = 'opening time/valve (s)';

            % Create PrimingOntimevalvesSpinner
            app.PrimingOntimevalvesSpinner = uispinner(app.PrimingPanel);
            app.PrimingOntimevalvesSpinner.Limits = [1 30];
            app.PrimingOntimevalvesSpinner.ValueChangedFcn = createCallbackFcn(app, @PrimingOntimevalvesSpinnerValueChanged, true);
            app.PrimingOntimevalvesSpinner.Position = [174 279 49 22];
            app.PrimingOntimevalvesSpinner.Value = 7;

            % Create PrimingValveStandbyLabel
            app.PrimingValveStandbyLabel = uilabel(app.PrimingPanel);
            app.PrimingValveStandbyLabel.BackgroundColor = [1 1 1];
            app.PrimingValveStandbyLabel.HorizontalAlignment = 'center';
            app.PrimingValveStandbyLabel.FontSize = 20;
            app.PrimingValveStandbyLabel.FontWeight = 'bold';
            app.PrimingValveStandbyLabel.Position = [256 276 163 45];
            app.PrimingValveStandbyLabel.Text = 'Valve: Standby';

            % Create PrimingLoopStandbyLabel
            app.PrimingLoopStandbyLabel = uilabel(app.PrimingPanel);
            app.PrimingLoopStandbyLabel.BackgroundColor = [1 1 1];
            app.PrimingLoopStandbyLabel.HorizontalAlignment = 'center';
            app.PrimingLoopStandbyLabel.FontSize = 20;
            app.PrimingLoopStandbyLabel.FontWeight = 'bold';
            app.PrimingLoopStandbyLabel.Position = [432 276 161 45];
            app.PrimingLoopStandbyLabel.Text = ' Loop: Standby';

            % Create waittimebetweenvalvessSpinnerLabel_3
            app.waittimebetweenvalvessSpinnerLabel_3 = uilabel(app.PrimingPanel);
            app.waittimebetweenvalvessSpinnerLabel_3.HorizontalAlignment = 'right';
            app.waittimebetweenvalvessSpinnerLabel_3.FontColor = [1 1 1];
            app.waittimebetweenvalvessSpinnerLabel_3.Position = [15 233 156 22];
            app.waittimebetweenvalvessSpinnerLabel_3.Text = 'wait time between valves (s)';

            % Create PrimingWaittimeSpinner
            app.PrimingWaittimeSpinner = uispinner(app.PrimingPanel);
            app.PrimingWaittimeSpinner.Limits = [0 30];
            app.PrimingWaittimeSpinner.Position = [174 233 49 22];
            app.PrimingWaittimeSpinner.Value = 2;

            % Create PrimingLamp
            app.PrimingLamp = uilamp(app.PrimingPanel);
            app.PrimingLamp.Position = [142 158 20 20];
            app.PrimingLamp.Color = [0.502 0.502 0.502];

            % Create PrimingTimer
            app.PrimingTimer = uigauge(app.PrimingPanel, 'circular');
            app.PrimingTimer.Limits = [0 30];
            app.PrimingTimer.MajorTicks = [0 3 6 9 12 15 18 21 24 27 30];
            app.PrimingTimer.MinorTicks = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
            app.PrimingTimer.Position = [337 86 183 183];

            % Create PrimingTimerTextArea
            app.PrimingTimerTextArea = uitextarea(app.PrimingPanel);
            app.PrimingTimerTextArea.Editable = 'off';
            app.PrimingTimerTextArea.HorizontalAlignment = 'center';
            app.PrimingTimerTextArea.FontWeight = 'bold';
            app.PrimingTimerTextArea.Position = [394 74 69 37];
            app.PrimingTimerTextArea.Value = {'Residual '; 'time (s)'};

            % Create PrimingSpecialDropDown
            app.PrimingSpecialDropDown = uidropdown(app.PrimingPanel);
            app.PrimingSpecialDropDown.Items = {'None', 'Flush', 'Alt1', 'Alt2', 'Alt3', 'Alt4'};
            app.PrimingSpecialDropDown.ItemsData = {'0', '1', '2', '3', '4', '5'};
            app.PrimingSpecialDropDown.Position = [174 209 68 22];
            app.PrimingSpecialDropDown.Value = '0';

            % Create PrimingWaittimeSpinnerLabel
            app.PrimingWaittimeSpinnerLabel = uilabel(app.PrimingPanel);
            app.PrimingWaittimeSpinnerLabel.HorizontalAlignment = 'right';
            app.PrimingWaittimeSpinnerLabel.FontColor = [1 1 1];
            app.PrimingWaittimeSpinnerLabel.Position = [93 209 74 22];
            app.PrimingWaittimeSpinnerLabel.Text = 'special valve';

            % Create valvedirectionSwitchLabel
            app.valvedirectionSwitchLabel = uilabel(app.PrimingPanel);
            app.valvedirectionSwitchLabel.HorizontalAlignment = 'center';
            app.valvedirectionSwitchLabel.FontColor = [1 1 1];
            app.valvedirectionSwitchLabel.Position = [57 185 82 22];
            app.valvedirectionSwitchLabel.Text = 'valve direction';

            % Create PrimingValvedirectionSwitch
            app.PrimingValvedirectionSwitch = uiswitch(app.PrimingPanel, 'slider');
            app.PrimingValvedirectionSwitch.Items = {'1->8', '8->1'};
            app.PrimingValvedirectionSwitch.ItemsData = [0 1];
            app.PrimingValvedirectionSwitch.FontColor = [1 1 1];
            app.PrimingValvedirectionSwitch.Position = [173 186 45 20];
            app.PrimingValvedirectionSwitch.Value = 0;

            % Create CleaningTab
            app.CleaningTab = uitab(app.TabGroup);
            app.CleaningTab.Title = 'Cleaning';
            app.CleaningTab.BackgroundColor = [0.0745 0.6235 1];

            % Create CleaningPanel
            app.CleaningPanel = uipanel(app.CleaningTab);
            app.CleaningPanel.ForegroundColor = [1 1 1];
            app.CleaningPanel.BackgroundColor = [0.0745 0.6235 1];
            app.CleaningPanel.Position = [1 2 639 340];

            % Create pressurepsiSpinnerLabel
            app.pressurepsiSpinnerLabel = uilabel(app.CleaningPanel);
            app.pressurepsiSpinnerLabel.HorizontalAlignment = 'right';
            app.pressurepsiSpinnerLabel.FontColor = [1 1 1];
            app.pressurepsiSpinnerLabel.Position = [6 253 79 22];
            app.pressurepsiSpinnerLabel.Text = 'pressure (psi)';

            % Create CleaningpressurepsiSpinner
            app.CleaningpressurepsiSpinner = uispinner(app.CleaningPanel);
            app.CleaningpressurepsiSpinner.Limits = [0 30];
            app.CleaningpressurepsiSpinner.Position = [88 253 49 22];
            app.CleaningpressurepsiSpinner.Value = 30;

            % Create CleaningStartButton
            app.CleaningStartButton = uibutton(app.CleaningPanel, 'push');
            app.CleaningStartButton.ButtonPushedFcn = createCallbackFcn(app, @CleaningStartButtonPushed, true);
            app.CleaningStartButton.Position = [21 209 100 22];
            app.CleaningStartButton.Text = 'Start';

            % Create timeminSpinnerLabel
            app.timeminSpinnerLabel = uilabel(app.CleaningPanel);
            app.timeminSpinnerLabel.HorizontalAlignment = 'right';
            app.timeminSpinnerLabel.FontColor = [1 1 1];
            app.timeminSpinnerLabel.Position = [26 276 59 22];
            app.timeminSpinnerLabel.Text = 'time (min)';

            % Create CleaningTimeSpinner
            app.CleaningTimeSpinner = uispinner(app.CleaningPanel);
            app.CleaningTimeSpinner.Limits = [1 20];
            app.CleaningTimeSpinner.ValueChangedFcn = createCallbackFcn(app, @CleaningTimeSpinnerValueChanged, true);
            app.CleaningTimeSpinner.Position = [88 276 49 22];
            app.CleaningTimeSpinner.Value = 10;

            % Create CleaningTimer
            app.CleaningTimer = uigauge(app.CleaningPanel, 'circular');
            app.CleaningTimer.Limits = [0 20];
            app.CleaningTimer.MajorTicks = [0 2 4 6 8 10 12 14 16 18 20];
            app.CleaningTimer.MinorTicks = [0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8 8.5 9 9.5 10 10.5 11 11.5 12 12.5 13 13.5 14 14.5 15 15.5 16 16.5 17 17.5 18 18.5 19 19.5 20];
            app.CleaningTimer.Position = [388 160 164 164];

            % Create CleaningTimerTextArea
            app.CleaningTimerTextArea = uitextarea(app.CleaningPanel);
            app.CleaningTimerTextArea.Editable = 'off';
            app.CleaningTimerTextArea.HorizontalAlignment = 'center';
            app.CleaningTimerTextArea.FontWeight = 'bold';
            app.CleaningTimerTextArea.Position = [406 157 125 21];
            app.CleaningTimerTextArea.Value = {'Residual time (min)'};

            % Create CleaningLamp
            app.CleaningLamp = uilamp(app.CleaningPanel);
            app.CleaningLamp.Position = [125 210 20 20];
            app.CleaningLamp.Color = [0.502 0.502 0.502];

            % Create CleaningCheckBox
            app.CleaningCheckBox = uicheckbox(app.CleaningPanel);
            app.CleaningCheckBox.ValueChangedFcn = createCallbackFcn(app, @CleaningCheckBoxValueChanged, true);
            app.CleaningCheckBox.Text = '';
            app.CleaningCheckBox.Position = [125 156 25 22];

            % Create CleaningQuickflushButton
            app.CleaningQuickflushButton = uibutton(app.CleaningPanel, 'push');
            app.CleaningQuickflushButton.ButtonPushedFcn = createCallbackFcn(app, @CleaningQuickflushButtonPushed, true);
            app.CleaningQuickflushButton.Enable = 'off';
            app.CleaningQuickflushButton.Position = [19 156 100 22];
            app.CleaningQuickflushButton.Text = '15 s quick flush';

            % Create AboutTab
            app.AboutTab = uitab(app.TabGroup);
            app.AboutTab.Title = 'About';

            % Create AboutPanel
            app.AboutPanel = uipanel(app.AboutTab);
            app.AboutPanel.Position = [1 2 638 340];

            % Create AboutTextArea
            app.AboutTextArea = uitextarea(app.AboutPanel);
            app.AboutTextArea.Editable = 'off';
            app.AboutTextArea.Position = [8 153 619 177];
            app.AboutTextArea.Value = {'Octaflow II Control App V1.0 was designed with MATLAB R2021b by Michael Rabenstein'; ''; 'Octaflow II™ is a trademark of ALA Scientific Instruments, Inc., Farmingdale, NY, USA.'; ''; 'This app includes the CyUSB.dll v. 1.2.3.0 from the Cypress Semiconductor Corp., San Jose, CA, USA.'; 'Usage is only allowed with the Octaflow II ™ system or other devices with Cypress controllers.'; ''; 'No official released control app, use at your own risk'; ''; ''; 'For further information please refer to the manual'};

            % Create ConnectionlostPanel
            app.ConnectionlostPanel = uipanel(app.OctaflowIIControlAppUIFigure);
            app.ConnectionlostPanel.Title = 'Connection lost';
            app.ConnectionlostPanel.Position = [656 -65 638 508];

            % Create TextArea_4
            app.TextArea_4 = uitextarea(app.ConnectionlostPanel);
            app.TextArea_4.Editable = 'off';
            app.TextArea_4.HorizontalAlignment = 'center';
            app.TextArea_4.FontSize = 24;
            app.TextArea_4.Position = [167 198 324 112];
            app.TextArea_4.Value = {'Connection with Octaflow II system lost.'; 'restart device '};

            % Create ClosePanel
            app.ClosePanel = uipanel(app.OctaflowIIControlAppUIFigure);
            app.ClosePanel.Title = 'Close';
            app.ClosePanel.Position = [656 -582 638 508];

            % Create CloseLabel
            app.CloseLabel = uilabel(app.ClosePanel);
            app.CloseLabel.HorizontalAlignment = 'center';
            app.CloseLabel.FontSize = 20;
            app.CloseLabel.Position = [180 266 284 24];
            app.CloseLabel.Text = 'Closing app...';

            % Create TextArea_17
            app.TextArea_17 = uitextarea(app.OctaflowIIControlAppUIFigure);
            app.TextArea_17.FontSize = 20;
            app.TextArea_17.FontWeight = 'bold';
            app.TextArea_17.Position = [54 -83 451 60];
            app.TextArea_17.Value = {'Programmer''s note: not visible elements in GUI figure. Make them visible first for editing'};

            % Create ManualButton
            app.ManualButton = uibutton(app.OctaflowIIControlAppUIFigure, 'push');
            app.ManualButton.ButtonPushedFcn = createCallbackFcn(app, @ManualButtonPushed, true);
            app.ManualButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.ManualButton.FontWeight = 'bold';
            app.ManualButton.Position = [261 484 100 22];
            app.ManualButton.Text = 'Manual';

            % Create BreakPushedLabel
            app.BreakPushedLabel = uilabel(app.OctaflowIIControlAppUIFigure);
            app.BreakPushedLabel.BackgroundColor = [0.5882 0 0];
            app.BreakPushedLabel.HorizontalAlignment = 'center';
            app.BreakPushedLabel.FontSize = 20;
            app.BreakPushedLabel.FontColor = [1 1 1];
            app.BreakPushedLabel.Position = [150 -182 306 64];
            app.BreakPushedLabel.Text = 'Break button pushed';

            % Show the figure after all components are created
            app.OctaflowIIControlAppUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Octaflow_control_exported

            runningApp = getRunningApp(app);

            % Check for running singleton app
            if isempty(runningApp)

                % Create UIFigure and components
                createComponents(app)

                % Register the app with App Designer
                registerApp(app, app.OctaflowIIControlAppUIFigure)

                % Execute the startup function
                runStartupFcn(app, @startupFcn)
            else

                % Focus the running singleton app
                figure(runningApp.OctaflowIIControlAppUIFigure)

                app = runningApp;
            end

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.OctaflowIIControlAppUIFigure)
        end
    end
end