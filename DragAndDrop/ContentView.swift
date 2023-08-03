//
//  ContentView.swift
//  DragAndDrop
//
//  Created by Rohan on 8/3/23.
//

import SwiftUI
import Algorithms

struct ContentView: View {
    
    @State private var toDoTasks: [String] = ["Make Dinner","Leetcode Problem","Meditation"]
    @State private var inProgressTasks: [String] = ["SwiftUI Tutorial"]
    @State private var doneTasks: [String] = []
   
    @State private var isToDoTargeted = false
    @State private var isInProgressTargeted = false
    @State private var isDoneTargeted = false
    
    var body: some View {
        // Display 3 columns of Kanban views
        HStack(spacing: 12){
            KanbanView(title: "To Do", tasks: toDoTasks, isTargeted: isToDoTargeted)
                .dropDestination(for:String.self) { droppedTasks, location in
                    //code for successfull drop
                    for task in droppedTasks{
                        inProgressTasks.removeAll{ $0 == task }
                        doneTasks.removeAll{ $0 == task }
                    }
                    
                    toDoTasks += droppedTasks
                    //prevent duplication of dropped tasks using uniques() method from Algorithms package. Can use Set instead of array as well
                    toDoTasks = Array(toDoTasks.uniqued())
                    
                    return true
                    
                }isTargeted: { isTargeted in
                    isToDoTargeted = isTargeted
                }
            
            KanbanView(title: "In Progress", tasks: inProgressTasks, isTargeted: isInProgressTargeted)
                .dropDestination(for:String.self) { droppedTasks, location in
                    //code for successfull drop
                    for task in droppedTasks{
                        toDoTasks.removeAll{ $0 == task }
                        doneTasks.removeAll{ $0 == task }
                    }
                    
                    inProgressTasks += droppedTasks
                    //prevent duplication of dropped tasks using uniques() method from Algorithms package. Can use Set instead of array as well
                    inProgressTasks = Array(inProgressTasks.uniqued())
                    
                    return true
                    
                }isTargeted: { isTargeted in
                    isInProgressTargeted = isTargeted
                }
            
            
            KanbanView(title: "Done", tasks: doneTasks, isTargeted: isDoneTargeted)
                .dropDestination(for:String.self) { droppedTasks, location in
                    //code for successfull drop
                    for task in droppedTasks{
                        toDoTasks.removeAll{ $0 == task }
                        inProgressTasks.removeAll{ $0 == task }
                    }
                    
                    doneTasks += droppedTasks
                    //prevent duplication of dropped tasks using uniques() method from Algorithms package. Can use Set instead of array as well
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
    let tasks: [String]
    let isTargeted: Bool
    
    var body: some View{
        VStack(alignment: .leading){
            Text(title).font(.footnote.bold())
            
            ZStack{
                RoundedRectangle(cornerRadius: 12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .teal.opacity(0.2) : Color(.secondarySystemFill))
                
                VStack(alignment: .leading, spacing: 12){
                    ForEach(tasks, id: \.self){ task in
                        Text(task)
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
