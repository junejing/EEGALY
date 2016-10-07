function addStartMarker_Callback(hObject, eventdata, handles)
% hObject    handle to addaro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
marker_start;
Mouse   =   handles.Mouse;
timedbtaro  =   Mouse(1,1);
    if ~isempty(handles.score{6,handles.currentscore})
        
        if sum(and(timedbtaro>handles.score{6,handles.currentscore}(:,1),...
                timedbtaro<handles.score{6,handles.currentscore}(:,2)))

            beep
            disp('Invalid "start Arousal" point')
            disp(' ')

        else
        
            handles.score{6,handles.currentscore}=...
                [handles.score{6,handles.currentscore}; ...
                timedbtaro timedbtaro];

            set(handles.addaro,'Label','Add "end Arousal" point');
            handles.addardeb(handles.currentscore) = 0;
            fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
            plot(ones(1,2)*timedbtaro,[0 handles.scale*(fact+1)], ...
                'UIContextMenu',handles.Delar,'Color',[0 0 0])
            text(timedbtaro,handles.scale*(fact+6/8), ...
                'S.Aro.','Color',[1 0 0],'FontSize',14)
            set(handles.axes1,'Color',[0.8 0.8 0.95]);

        end

    else

        handles.score{6,handles.currentscore}=...
            [handles.score{6,handles.currentscore};...
            timedbtaro timedbtaro];
        set(handles.addaro,'Label','Add "end Arousal" point');
        handles.addardeb(handles.currentscore) = 0;
        fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
        plot(ones(1,2)*timedbtaro,[0 handles.scale*(fact+1)], ...
            'UIContextMenu',handles.Delar,'Color',[0 0 0])
        text(timedbtaro,handles.scale*(fact+6/8), ...
            'S.Aro','Color',[1 0 0],'FontSize',14)
        set(handles.axes1,'Color',[0.8 0.8 0.95]);

    end
else
    timefinaro=Mouse(1,1);
    [row]=find(and(timefinaro>handles.score{6,handles.currentscore}(:,1),...
        timefinaro>handles.score{6,handles.currentscore}(:,2)));
    
    test3=sum(and(handles.score{6,handles.currentscore}...
        (size(handles.score{6,handles.currentscore},1),1)<...
        handles.score{6,handles.currentscore}(row,1), ...
        handles.score{6,handles.currentscore}...
        (size(handles.score{6,handles.currentscore},1),2)<...
        handles.score{6,handles.currentscore}(row,2)));

    if or(or(sum(and(timefinaro>handles.score{6,handles.currentscore}(:,1),...
            timefinaro<handles.score{6,handles.currentscore}(:,2)))>0, ...
            timefinaro<handles.score{6,handles.currentscore}...
            (size(handles.score{6,handles.currentscore},1),2)),test3)

        beep
        disp('Invalid "end Arousal" point')
        disp(' ')
    else
        set(handles.addaro,'Label','Add "start Arousal" point');

        handles.score{6,handles.currentscore}...
            (size(handles.score{6,handles.currentscore},1),2)= timefinaro;

        handles.addardeb(handles.currentscore) = 1;
        fact    =   min(str2double(get(handles.NbreChan,'String')),length(handles.indnomeeg) + length(handles.indexMEEG));
        plot(ones(1,2)*timefinaro,[0 handles.scale*(fact+1)], ...
            'UIContextMenu',handles.Delar,'Color',[0 0 0])
        text(timefinaro,handles.scale*(fact+6/8), ...
            'E.Aro','Color',[1 0 0],'FontSize',14)
        set(handles.axes1,'Color',[1 1 1]);
        set(handles.figure1,'CurrentAxes',handles.axes4)
        plot(handles.score{6,handles.currentscore}(size(handles.score{6,handles.currentscore},1),1),ones(1,1)*8,...
            '+','MarkerSize',8,'MarkerFaceColor',[1 0 0],...
            'MarkerEdgeColor',[1 0 0],'tag','arou')
        set(handles.figure1,'CurrentAxes',handles.axes1)
    end
end

% Save the changes
handles.Dmeg{1}.CRC.score = handles.score;
save(handles.Dmeg{1});

% Update handles structure
guidata(hObject, handles);
