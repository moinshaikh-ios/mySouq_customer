//
//  OrderTrackVCViewController.swift
//  Bazaar Ghar
//
//  Created by Developer on 02/12/2024.
//

import UIKit
import StepperView
import SwiftUI


class OrderTrackVCViewController: UIViewController {
    @IBOutlet weak var headerBackgroudView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var stepperView: UIView!
    @IBOutlet weak var verticalStepperView: UIView!
    @IBOutlet weak var stepperheight: NSLayoutConstraint!
    @IBOutlet weak var verticalstepperheight: NSLayoutConstraint!
    var singleOrderResponse: MyOrderResult?
    var orderStatuses: [OrderTrackingOrderStatus] = []
    var orderTracks: [OrderTrack] = []
    
    var orderID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
         
        headerBackgroudView.backgroundColor = UIColor(named: "headercolor")
        self.headerLbl.text = "Order Tracking"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        orderTrack(id: singleOrderResponse?.id ?? "")
    }
    func createVerticalStepper(orderTracking: [OrderTrack]) -> UIView {
       let orderTracking  = orderTracking.reversed()
        
        // Map the `OrderTrack` data into `ImageTextRowView`
        let cells = orderTracking.enumerated().map { (index, track) in
//
            // Check if the index is 0 to set text color
            let textColor = (index == 0) ? Colors.black.rawValue : Colors.gray(.light).rawValue
            
            return ImageTextRowView(text: "\(track.status ?? "Unknown Status")",dataText: formatDateString(from: track.date ?? ""), textcolor: textColor)
        }

        // Define alignments for steps
        let alignments = Array(repeating: StepperAlignment.top, count: cells.count)

        // Define indication types
        
        let indicationTypes = orderTracking.enumerated().map { (index, _) in
                // Check if it's the first index (0) to set the color to black, otherwise grey
            let color = (index == 0) ? .green : Colors.gray(.light).rawValue
                
                // Return StepperIndicationType with the respective color
                return StepperIndicationType.custom(
                    Image(.radioOn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(color) // Black for current and previous, Gray for others
                        .eraseToAnyView()
                )
            }

       
        // Create the StepperView
//        let stepperView = StepperView()
//            .addSteps(cells)
//            .alignments(alignments)
//            .stepIndicatorMode(StepperMode.vertical)
//            .indicators(indicationTypes)
//            .lineOptions(StepperLineOptions.custom(1, Colors.gray(.light).rawValue))
let stepperView =
        StepperView()
                .addSteps(cells)
                .indicators(indicationTypes)
                .stepIndicatorMode(StepperMode.vertical)
                .spacing(60)
                .lineOptions(StepperLineOptions.custom(1, Colors.gray(.light).rawValue))

        // Embed the StepperView in a UIHostingController
        let controller = UIHostingController(rootView: stepperView)
        controller.view.backgroundColor = .clear
        return controller.view
    }
   
    
    func orderTrack(id: String) {
        print("_________oderId____________\(singleOrderResponse?.id)")
        APIServices.orderTracking(id: id) { [weak self] data in
            switch data {
            case .success(let res):
                DispatchQueue.main.async {
                    // Ensure the orderStatuses and orderTrack are not nil or empty
                    guard let self = self, res.orderTrack?.count ?? 0 > 0 else {
                        print("No order statuses or invalid data")
                        return
                    }
                    
                    self.stepperView.subviews.forEach { $0.removeFromSuperview() }
                                    self.verticalStepperView.subviews.forEach { $0.removeFromSuperview() }
                    
                    // Create stepper view with current status
                     let stepperContent = self.createStepperView(currentStatus: res.orderStatus?.name ?? "")
                        self.stepperView.addSubview(stepperContent)
                        stepperContent.translatesAutoresizingMaskIntoConstraints = false
                        
                        // Set Auto Layout constraints for stepperContent
                        NSLayoutConstraint.activate([
                            stepperContent.leadingAnchor.constraint(equalTo: self.stepperView.leadingAnchor),
                            stepperContent.trailingAnchor.constraint(equalTo: self.stepperView.trailingAnchor),
                            stepperContent.topAnchor.constraint(equalTo: self.stepperView.topAnchor),
                            stepperContent.bottomAnchor.constraint(equalTo: self.stepperView.bottomAnchor)
                        ])
                        
                        // Force layout to calculate the size of the stepper content
                        self.stepperView.layoutIfNeeded()
                        
                        // Optionally animate the change in layout
                        UIView.animate(withDuration: 0.3) {
                            self.stepperView.layoutIfNeeded()
                        }
                    

                    // Proceed with vertical stepper if orderTrack data is available
                     let stepperVerticalContent = self.createVerticalStepper(orderTracking: res.orderTrack ?? [])
                        self.verticalStepperView.addSubview(stepperVerticalContent)
                        stepperVerticalContent.translatesAutoresizingMaskIntoConstraints = false
                        
                        // Set Auto Layout constraints for stepperVerticalContent
                        NSLayoutConstraint.activate([
                            stepperVerticalContent.leadingAnchor.constraint(equalTo: self.verticalStepperView.leadingAnchor),
                            stepperVerticalContent.trailingAnchor.constraint(equalTo: self.verticalStepperView.trailingAnchor),
                            stepperVerticalContent.topAnchor.constraint(equalTo: self.verticalStepperView.topAnchor),
                            stepperVerticalContent.bottomAnchor.constraint(equalTo: self.verticalStepperView.bottomAnchor)
                        ])
                        
                        // Force layout to calculate the size of the vertical stepper content
                        self.verticalStepperView.layoutIfNeeded()
                        
                        // Dynamically adjust the height based on the number of steps
                        let stepHeight: CGFloat = 100 // Fixed height per step
                    let height = CGFloat(res.orderTrack?.count ?? 0) * stepHeight
                        self.stepperheight.constant = 115
                        self.verticalstepperheight.constant = height
                        
                        // Optionally animate the change in height (if needed)
                        UIView.animate(withDuration: 0.3) {
                            self.verticalStepperView.layoutIfNeeded()
                        }
                    
                }
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func createStepperView(currentStatus: String) -> UIView {


        let statuses = ["new", "confirmed", "ready", "shipped", "delivered", "completed"]
            
            // Find the index of the current status
            guard let currentIndex = statuses.firstIndex(of: currentStatus) else {
                fatalError("Invalid status received from backend")
            }
            
            // Determine which statuses to show
            var displayedStatuses: [String] = []
            if currentIndex == 0 {
                // Show first three statuses if the current status is the first one
                displayedStatuses = Array(statuses.prefix(3))
            } else if currentIndex == statuses.count - 1 {
                // Show the last three statuses if the current status is the last one
                displayedStatuses = Array(statuses.suffix(3))
            } else {
                // Show the previous, current, and next statuses for intermediate cases
                displayedStatuses = statuses[max(currentIndex - 1, 0)...min(currentIndex + 1, statuses.count - 1)].map { $0 }
            }
            
            // Create steps with dynamic color for the text
            let steps = displayedStatuses.map { status in
              
                CenterAlignedStatusesView(displayedStatuses: status)

            }
            
  
        
        let indicators = displayedStatuses.enumerated().map { index, status in
                StepperIndicationType.custom(
                    Image(.radioOn)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundColor(statuses.firstIndex(of: status)! <= currentIndex ? .green : .gray) // Black for current and previous, Gray for others
                        .eraseToAnyView()
                )
            }
                                                                                                             
      
            
            // Assign life cycles based on the current index
            let stepLifeCycles = displayedStatuses.enumerated().map { index, status in
                let statusIndex = statuses.firstIndex(of: status)!
                if statusIndex <= currentIndex {
                    return StepLifeCycle.completed
                } else {
                    return StepLifeCycle.pending
                }
            }
        func getScreenHeight() -> CGFloat {
            return UIScreen.main.bounds.height
        }
        
        
        
            // Create the SwiftUI StepperView
            let stepper = StepperView()
                .addSteps(steps)
                .indicators(indicators)
                .spacing(getScreenHeight() > 844 ? 145 : 117 )
                .stepIndicatorMode(StepperMode.horizontal)
                .lineOptions(StepperLineOptions.rounded(1, 5, .gray))
                .lineSpacing(0)
                .stepLifeCycles(stepLifeCycles)
                .spacing(120) // Adjust spacing automatically
            
            // Embed SwiftUI into UIView
            let controller = UIHostingController(rootView: stepper)
            controller.view.backgroundColor = .clear
            return controller.view
        
    }
    
   
}





struct ImageTextRowView: View {
    var text: String
    var dataText: String
    var textcolor: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                   Text(text)
                .foregroundColor(textcolor)
                                    .font(.system(size: 14, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading) // Align text to
                                    .lineLimit(nil) // Allow unlimited lines
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 18)// Dynamically
                   
                   Text(dataText)
                       .foregroundColor(textcolor)
                       .font(.system(size: 14))
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .multilineTextAlignment(.leading)
                       .fixedSize(horizontal: false, vertical: true)
                       .padding(.top, 4)// Dynamically
            
               }
                // Adjust vertical padding
        .padding(.trailing, 12) // Adjust horizontal padding
  
    }
}

func formatDateString(from isoDateString: String) -> String {
    // Create ISO8601 date formatter with a custom options to handle 'Z' for UTC
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    isoFormatter.timeZone = TimeZone.current

    if let date = isoFormatter.date(from: isoDateString) {
        // If date is valid, format it to the desired format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, hh:mm a"  // Example: "05 Dec 2024, 04:30 PM"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    return "Invalid Date"  // Return this if the date is not valid
}
struct CenterAlignedStatusesView: View {
    var displayedStatuses: String

    var body: some View {
        VStack(alignment: .center){ // Use VStack for vertical alignment
       
                Text(displayedStatuses.capitalized)
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
                    .foregroundColor(.black)
                    .padding(.bottom,12)
            // Adjust color as needed
            
        }
        
         // Center align in the parent view
        
    }
}
