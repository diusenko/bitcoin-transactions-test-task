//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
/// There is an example of a _bad_ services relationship built on `onRateUpdate` callback
/// This kind of relationship must be refactored with a more convenient and reliable approach
///
/// It's ok to move the logging to model/viewModel/interactor/etc when you have 1-2 modules in your app
/// Imagine having rate updates in 20-50 diffent modules
/// Make this logic not depending on any module

protocol ServicesAssembler {
    var bitcoinRateService: any BitcoinRateService { get }
    var transactionService: TransactionsService { get }
    var accountBalanceService: any AccountBalanceService { get }
}

final class ServicesAssemblerImpl: ServicesAssembler {

    // MARK: - Public Lazy Properties

    var bitcoinRateService: any BitcoinRateService {
        return self._bitcoinRateService
    }
    
    var transactionService: TransactionsService {
        return self._transactionService
    }

    var accountBalanceService: any AccountBalanceService {
        return self._accountBalanceService
    }
    
    // MARK: - Private Lazy Properties

    private lazy var _transactionService: TransactionsService = {
        return TransactionsServiceImpl(networkService: self._networkService)
    }()
    
    private lazy var _accountBalanceService: any AccountBalanceService = {
        let balanceFetcher = self._accountBalanceFetchService
        
        return AccountBalanceServiceImpl(balanceFetchService: balanceFetcher)
    }()
    
    private lazy var _bitcoinRateService: any BitcoinRateService = {
        return BitcoinRateServiceImpl(
            bpiRateFetcherService: self._bpiRateFetcherService,
            timer: self._timer
        )
    }()
    
    private lazy var _accountBalanceFetchService: AccountBalanceFetchService = {
        return AccountBalanceFetchServiceImpl(networkService: self._networkService)
    }()

    private lazy var _bpiRateFetcherService: BPIRateFetcherService = {
        return BPIRateFetcherServiceImpl(networkService: self._networkService)
    }()

    private lazy var _networkService: NetworkService = {
        return NetworkServiceImpl(
            errorProcessor: self._errorProcessor,
            responseProcessor: self._responseProcessor
        )
    }()

    private lazy var _errorProcessor: ErrorProcessor = {
        return ErrorProcessorImpl()
    }()

    private lazy var _responseProcessor: ResponseProcessor = {
        return ResponseProcessorImpl()
    }()

    private lazy var _timer: Timer = {
        return TimerIml()
    }()

    private lazy var _analyticsService: AnalyticsService = {
        return AnalyticsServiceImpl()
    }()
    
    private lazy var _subscriberLogger: SubscriberLoggerImpl = {
        let logger = SubscriberLoggerImpl(analyticsService: self._analyticsService)
        
        if let bpi = self._bitcoinRateService.events {
            let id = "\(type(of: self._bitcoinRateService))"
            logger.addSubscription(publisher: bpi, with: id)
        }
        
        return logger
    }()
}
