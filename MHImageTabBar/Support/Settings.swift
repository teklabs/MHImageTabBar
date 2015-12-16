import Foundation

public class Settings {
    public class func registerDefaults() {
        let userDefaults = NSUserDefaults.groupUserDefaults()

        // The defaults registered with registerDefaults are ignore by the Today Extension. :/
        if (!userDefaults.boolForKey("DEFAULTS_INSTALLED")) {
            userDefaults.setBool(true, forKey: "DEFAULTS_INSTALLED")
            userDefaults.setInteger(ComplexConstants.UnitsOfMeasure.Liters.rawValue, forKey: ComplexConstants.General.UnitOfMeasure.key())
            userDefaults.setDouble(0.5, forKey: ComplexConstants.Prayr.Big.key())
            userDefaults.setDouble(0.2, forKey: ComplexConstants.Prayr.Small.key())
            userDefaults.setDouble(2, forKey: ComplexConstants.Prayr.Goal.key())
            userDefaults.setBool(false, forKey: ComplexConstants.Health.On.key())
            userDefaults.setBool(true, forKey: ComplexConstants.Notification.On.key())
            userDefaults.setInteger(10, forKey: ComplexConstants.Notification.From.key())
            userDefaults.setInteger(22, forKey: ComplexConstants.Notification.To.key())
            userDefaults.setInteger(2, forKey: ComplexConstants.Notification.Interval.key())
        }
        userDefaults.synchronize()
    }

    public class func watchData(current current: Double) -> [String: Double] {
        let userDefaults = NSUserDefaults.groupUserDefaults()
        return [
            ComplexConstants.Prayr.Goal.key(): userDefaults.doubleForKey(ComplexConstants.Prayr.Goal.key()),
            ComplexConstants.WatchContext.Current.key(): current,
            ComplexConstants.Prayr.Small.key(): userDefaults.doubleForKey(ComplexConstants.Prayr.Small.key()),
            ComplexConstants.Prayr.Big.key(): userDefaults.doubleForKey(ComplexConstants.Prayr.Big.key())]
    }
    
    

}
