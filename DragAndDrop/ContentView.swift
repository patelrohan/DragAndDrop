//
//  ContentView.swift
//  DragAndDrop
//
//  Created by Rohan on 8/3/23.
//

import SwiftUI
import Algorithms
import UniformTypeIdentifiers

struct ContentView: View {
    
    @State private var toDoTasks: [DeveloperTask] = [MockData.taskTwo, MockData.taskThree, MockData.taskFour]
    @State private var inProgressTasks: [DeveloperTask] = [MockData.taskOne]
    @State private var doneTasks: [DeveloperTask] = []
   
    @State private var isToDoTargeted = false
    @State private var isInProgressTargeted = false
    @State private var isDoneTargeted = false
    
    var body: some View {
        // Display 3 columns of Kanban views
        HStack(spacing: 12){
            KanbanView(title: "To Do", tasks: toDoTasks, isTargeted: isToDoTargeted)
                .dropDestination(for:DeveloperTask.self) { droppedTasks, location in
                    //code for successfull drop
                    for task in droppedTasks{
                        inProgressTasks.removeAll{ $0.id == task.id }
                        doneTasks.removeAll{ $0.id == task.id }
                    }
                    
                    toDoTasks += droppedTasks
                    toDoTasks = Array(toDoTasks.uniqued())
                    
                    return true
                    
                }isTargeted: { isTargeted in
                    isToDoTargeted = isTargeted
                }
            
            KanbanView(title: "In Progress", tasks: inProgressTasks, isTargeted: isInProgressTargeted)
                .dropDestination(for:DeveloperTask.self) { droppedTasks, location in
                    //code for successfull drop
                    for task in droppedTasks{
                        toDoTasks.removeAll{ $0.id == task.id }
                        doneTasks.removeAll{ $0.id == task.id }
                    }
                    
                    inProgressTasks += droppedTasks
                    //prevent duplication of dropped tasks using uniques() method from Algorithms package.
                    //Can use Set instead of array as well
                    inProgressTasks = Array(inProgressTasks.uniqued())
                    
                    return true
                    
                }isTargeted: { isTargeted in
                    isInProgressTargeted = isTargeted
                }
            
            
            KanbanView(title: "Done", tasks: doneTasks, isTargeted: isDoneTargeted)
                .dropDestination(for:DeveloperTask.self) { droppedTasks, location in
                    //code for successfull drop
                    for task in droppedTasks{
                        toDoTasks.removeAll{ $0.id == task.id }
                        inProgressTasks.removeAll{ $0.id == task.id }
                    }
                    
                    doneTasks += droppedTasks
                    doneTasks = Array(doneTasks.uniqued())
                    
                    return true
                    
                }isTargeted: { isTargeted in
                    isDoneTargeted = isTargeted
                }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

// Setup custom view for Kanban
struct KanbanView: View{
    
    let title: String
    let tasks: [DeveloperTask]
    let isTargeted: Bool
    
    var body: some View{
        VStack(alignment: .center){
            Text(title)
                .font(.footnote.bold())
                
            
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .teal.opacity(0.2) : Color(.secondarySystemFill))
                
                VStack(alignment: .leading, spacing: 12){
                    ForEach(tasks, id: \.id){ task in
                        Text(task.title)
                            .padding(12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 1, x: 1, y: 1)
                            .draggable(task)
                    }
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}
struct DeveloperTask: Transferable, Codable, Hashable{
    let id: UUID
    let title: String
    let owner: String
    let note: String
    
    static var transferRepresentation: some TransferRepresentation{
        CodableRepresentation(contentType: .developerTask)
    }
}

extension UTType{
    static let developerTask = UTType(exportedAs: "rohan-patel.DragAndDrop")
}

struct MockData{
    static let taskOne = DeveloperTask(id: UUID(), title: "SwiftUI Tutorial", owner: "Rohan", note: "Weekend project")
    
    
    static let taskTwo = DeveloperTask(id: UUID(), title: "Cleanup and Organize Home", owner: "Family", note: "Weekend task for everyone")
    
    
    static let taskThree = DeveloperTask(id: UUID(), title: "Leetcode Problem", owner: "Rohan", note: "1 Leetcode a day keeps unemployment away!")
    
    
    static let taskFour = DeveloperTask(id: UUID(), title: "Family Meditation", owner: "Rohan", note: "Daily task of mindfulness")
}
