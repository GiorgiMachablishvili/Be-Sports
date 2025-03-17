

import UIKit

class MainViewControllerTab: UITabBarController,  UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackBackgroundColor
        self.delegate = self

        // Instantiate the three view controllers
        let workoutsViewVC = WorkoutViewController()
        let likedWorkoutVC = LikedWorkoutViewController()
        let addWorkoutsVC = AddWorkoutViewController()

        // Create Navigation Controllers for each (optional for navigation stack)
        let workouts = UINavigationController(rootViewController: workoutsViewVC)
        let likeWorkouts = UINavigationController(rootViewController: likedWorkoutVC)
        let addedWorkouts = UINavigationController(rootViewController: addWorkoutsVC)

        workouts.navigationBar.isHidden = true
        likeWorkouts.navigationBar.isHidden = true
        addedWorkouts.navigationBar.isHidden = true

        // Configure tab bar items
        workouts.tabBarItem = UITabBarItem(
            title: nil,
            image: resizeImage(
                named: "home",
                size: CGSize(width: 30 * Constraint.xCoeff, height: 30 * Constraint.yCoeff)
            ),
            tag: 0
        )
        likeWorkouts.tabBarItem = UITabBarItem(
            title: nil,
            image: resizeImage(named: "heart", size: CGSize(width: 30 * Constraint.xCoeff, height: 30 * Constraint.yCoeff)),
            tag: 1
        )
        addedWorkouts.tabBarItem = UITabBarItem(
            title: nil,
            image: resizeImage(named: "plus", size: CGSize(width: 30 * Constraint.xCoeff, height: 30 * Constraint.yCoeff)),
            tag: 2
        )

        // Assign view controllers to the Tab Bar
        viewControllers = [workouts, likeWorkouts, addedWorkouts]

        workouts.tabBarItem.imageInsets = UIEdgeInsets(
            top: 6 * Constraint.yCoeff,
            left: 30 * Constraint.xCoeff,
            bottom: -6 * Constraint.yCoeff,
            right: -30 * Constraint.xCoeff
        )
        likeWorkouts.tabBarItem.imageInsets = UIEdgeInsets(
            top: 6 * Constraint.yCoeff,
            left: 0,
            bottom: -6 * Constraint.yCoeff,
            right: 0
        )
        addedWorkouts.tabBarItem.imageInsets = UIEdgeInsets(
            top: 6 * Constraint.yCoeff,
            left: -30 * Constraint.xCoeff,
            bottom: -6 * Constraint.yCoeff,
            right: 30 * Constraint.xCoeff
        )

        // Style the Tab Bar (optional)
        tabBar.tintColor = .redColor
        tabBar.unselectedItemTintColor = .white
        tabBar.barTintColor = UIColor.blackBackgroundColor
        tabBar.backgroundColor = UIColor.blackBackgroundColor
        tabBar.isTranslucent = false
    }

    private func resizeImage(named: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else { return nil }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
