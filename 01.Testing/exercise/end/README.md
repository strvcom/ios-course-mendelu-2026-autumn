# Testing

On the lecture we wrote a Unit test using XCTest framework and a UITest.
In this repo, you will find few more tests that you can play around with.

Make sure to check out:
- MapViewModelSwiftTests for SwiftTesting implementation
- MapViewModelTests and MapViewModelSwiftTests for showcase of testing with CoreData

We did not have time setup snapshot tests, so I am adding short tutorial on how to set them up below.

# How to write a snapshot test

A snapshot test renders a view to an image and compares it with a reference image saved in the repo. If the UI changes, the test fails and shows the difference.

## 1. Add the library

1. **File → Add Package Dependencies…**
2. Enter `https://github.com/pointfreeco/swift-snapshot-testing` and click **Add Package**.
3. Add the **SnapshotTesting** product to the unit test target (`CityGuideUnitTests`), not to the app.

## 2. Write the test

```swift
import SnapshotTesting
import XCTest
@testable import CityGuide

final class CityGuideSnapshotTests: XCTestCase {

    @MainActor
    func testDetailView() {
        let view = DetailView(
            viewModel: DetailViewModel(
                mapItem: .getSample(),
                connector: Connector(),
                // Failing API keeps the temperature at "100", so the image is the same every run
                apiManager: APIManagerMock(returnValue: .failure(APIError.noResponse))
            )
        )

        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
```

Give the view fixed data. Anything that changes between runs, like network data or the current date, makes the test fail.

## 3. Record and compare

1. Run the test. **The first run fails**, because there's no reference image yet. It saves one to `CityGuideUnitTests/__Snapshots__/CityGuideSnapshotTests/testDetailView.1.png`.
2. Open the PNG and check that it looks right.
3. Run the test again. It passes now.
4. Commit the `__Snapshots__` folder together with the test.

To see a failure, change something in `DetailView` and run the test again. The test fails, and its result in Xcode's Report navigator has the reference image, the new image and the difference between them attached.

## Tips

- Record and compare on the same simulator and iOS version. A different device or iOS version renders slightly differently and fails the test.
- If you change the UI on purpose, delete the old PNG and run the test to record a new one.
- More variants: `.image(layout: .device(config: .iPhone13), traits: .init(userInterfaceStyle: .dark))` takes a dark-mode snapshot.
