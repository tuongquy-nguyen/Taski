//
//  Home.swift
//  Tasky (iOS)
//
//  Created by KET on 03/05/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel = TaskViewModel.init()
    
    @Namespace var animation
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 9) {
                    Text("Welcome Back")
                        .font(.callout)
                    emojiReact(tab: taskModel.currentTab)
                        .font(.title3.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                TaskView()
                
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            Button {
                taskModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add new Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }

        }
        .fullScreenCover(isPresented: $taskModel.openEditTask) {
            taskModel.resetTaskData()
        } content: {
            AddNewTaskView(taskModel: taskModel)
        }

    }
    
    ///Custom segmented bar
    @ViewBuilder
    func CustomSegmentedBar() -> some View {
        let tabs = ["Today", "Upcoming", "Finished", "Failed"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(taskModel.currentTab == tab ? .white : .black)
                    .background {
                        if taskModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            taskModel.currentTab = tab
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func TaskView() -> some View {
        LazyVStack(spacing: 20) {
            DynamicFilterView(currentTab: taskModel.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func TaskRowView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.4))
                    }
                
                Spacer()
                
                if !task.isCompleted && taskModel.currentTab != "Failed" {
                    Button {
                        taskModel.editTask = task
                        taskModel.openEditTask = true
                        taskModel.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted && taskModel.currentTab != "Failed" {
                    Circle()
                        .strokeBorder(.black, lineWidth: 1.5)
                        .frame(width: 25, height: 25)
                        .contentShape(Circle())
                        .onTapGesture {
                            task.isCompleted.toggle()
                            try? env.managedObjectContext.save()
                        }
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
    
    func emojiReact(tab: String) -> some View {
        switch tab {
        case "Today":
            return Text("Here's your updates for today 👇:")
        case "Upcoming":
            return Text("Here's your updates in the future ⏳:")
        case "Finished":
            return Text("Here's your finished tasks 🥳:")
        default:
            return Text("Here's your failed tasks 😡:")
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.portrait)
    }
}
