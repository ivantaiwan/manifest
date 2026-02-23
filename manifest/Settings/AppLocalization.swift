import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case zhHant
    case en
    case ja
    case ko

    var id: String { rawValue }

    var label: String {
        switch self {
        case .zhHant: return "繁體中文"
        case .en: return "English"
        case .ja: return "日本語"
        case .ko: return "한국어"
        }
    }
}

enum LoginProvider: String, CaseIterable, Identifiable {
    case apple
    case google
    case email

    var id: String { rawValue }
}

enum LKey: String {
    case tabMorning, tabGratitude, tabMeditation, tabUniverse, tabSettings
    case morningTitle, gratitudeTitle, meditationTitle, universeTitle, settingsTitle
    case add, addTodoPlaceholder, saveGratitude, start, stop, changeQuote
    case today, streak, latestCompletion, quoteNoticeHint, completedMeditation
    case progress, doneProgress, mood, gratitudePrompt, universeQuote
    case defaultMorningTodo
    case calendar, selectPhotoOptional, selectedTodayPhoto, photoLabel
    case minuteUnit, secondUnit, dayUnit, notCompletedYet
    case done, ok, cancel
    case settingsLanguage, settingsLogin, settingsLoginHint
    case loginApple, loginGoogle, loginEmail
}

struct L10n {
    static func t(_ key: LKey, _ language: AppLanguage) -> String {
        switch language {
        case .zhHant:
            switch key {
            case .tabMorning: return "早晨"
            case .tabGratitude: return "感恩"
            case .tabMeditation: return "冥想"
            case .tabUniverse: return "宇宙"
            case .tabSettings: return "設定"
            case .morningTitle: return "早上 To-Do"
            case .gratitudeTitle: return "感恩日記"
            case .meditationTitle: return "睡前冥想"
            case .universeTitle: return "宇宙"
            case .settingsTitle: return "設定"
            case .add: return "新增"
            case .addTodoPlaceholder: return "新增待辦"
            case .saveGratitude: return "儲存今晚感恩"
            case .start: return "開始"
            case .stop: return "停止"
            case .changeQuote: return "換一句"
            case .today: return "今天"
            case .streak: return "冥想連續達成"
            case .latestCompletion: return "最近完成"
            case .quoteNoticeHint: return "通知會每天每 3 小時循環，並直接顯示一句宇宙小語"
            case .completedMeditation: return "你完成了一次睡前冥想"
            case .progress: return "今日進度"
            case .doneProgress: return "已完成"
            case .mood: return "心情"
            case .gratitudePrompt: return "今晚想感謝什麼？"
            case .universeQuote: return "宇宙小語"
            case .defaultMorningTodo: return "寫下今天最重要的一件事"
            case .calendar: return "日曆"
            case .selectPhotoOptional: return "選擇照片（可選）"
            case .selectedTodayPhoto: return "已選擇照片"
            case .photoLabel: return "照片"
            case .minuteUnit: return "分"
            case .secondUnit: return "秒"
            case .dayUnit: return "日"
            case .notCompletedYet: return "尚未完成"
            case .done: return "完成"
            case .ok: return "確定"
            case .cancel: return "取消"
            case .settingsLanguage: return "語言"
            case .settingsLogin: return "登入方式（預留）"
            case .settingsLoginHint: return "這一版先保留登入選擇，下一版可串真實帳號系統。"
            case .loginApple: return "Apple"
            case .loginGoogle: return "Google"
            case .loginEmail: return "Email"
            }
        case .en:
            switch key {
            case .tabMorning: return "Morning"
            case .tabGratitude: return "Gratitude"
            case .tabMeditation: return "Meditation"
            case .tabUniverse: return "Universe"
            case .tabSettings: return "Settings"
            case .morningTitle: return "Morning To-Do"
            case .gratitudeTitle: return "Gratitude Journal"
            case .meditationTitle: return "Night Meditation"
            case .universeTitle: return "Universe"
            case .settingsTitle: return "Settings"
            case .add: return "Add"
            case .addTodoPlaceholder: return "New task"
            case .saveGratitude: return "Save gratitude"
            case .start: return "Start"
            case .stop: return "Stop"
            case .changeQuote: return "New quote"
            case .today: return "Today"
            case .streak: return "Meditation streak"
            case .latestCompletion: return "Latest completion"
            case .quoteNoticeHint: return "A quote notification appears every 3 hours each day."
            case .completedMeditation: return "You completed one meditation session."
            case .progress: return "Today's progress"
            case .doneProgress: return "done"
            case .mood: return "Mood"
            case .gratitudePrompt: return "What are you grateful for tonight?"
            case .universeQuote: return "Universe Quote"
            case .defaultMorningTodo: return "Write the most important thing for today"
            case .calendar: return "Calendar"
            case .selectPhotoOptional: return "Choose photo (optional)"
            case .selectedTodayPhoto: return "Photo selected"
            case .photoLabel: return "Photo"
            case .minuteUnit: return "min"
            case .secondUnit: return "sec"
            case .dayUnit: return "days"
            case .notCompletedYet: return "Not completed yet"
            case .done: return "Done"
            case .ok: return "OK"
            case .cancel: return "Cancel"
            case .settingsLanguage: return "Language"
            case .settingsLogin: return "Login option (placeholder)"
            case .settingsLoginHint: return "Login selector is prepared in this version."
            case .loginApple: return "Apple"
            case .loginGoogle: return "Google"
            case .loginEmail: return "Email"
            }
        case .ja:
            switch key {
            case .tabMorning: return "朝"
            case .tabGratitude: return "感謝"
            case .tabMeditation: return "瞑想"
            case .tabUniverse: return "宇宙"
            case .tabSettings: return "設定"
            case .morningTitle: return "朝のTo-Do"
            case .gratitudeTitle: return "感謝日記"
            case .meditationTitle: return "就寝前の瞑想"
            case .universeTitle: return "宇宙"
            case .settingsTitle: return "設定"
            case .add: return "追加"
            case .addTodoPlaceholder: return "タスクを追加"
            case .saveGratitude: return "感謝を保存"
            case .start: return "開始"
            case .stop: return "停止"
            case .changeQuote: return "別の一言"
            case .today: return "今日"
            case .streak: return "連続達成"
            case .latestCompletion: return "最終達成日"
            case .quoteNoticeHint: return "3時間ごとに宇宙メッセージを通知します。"
            case .completedMeditation: return "瞑想を1回達成しました。"
            case .progress: return "今日の進捗"
            case .doneProgress: return "完了"
            case .mood: return "気分"
            case .gratitudePrompt: return "今夜の感謝を書いてください"
            case .universeQuote: return "宇宙メッセージ"
            case .defaultMorningTodo: return "今日いちばん大事なことを書く"
            case .calendar: return "カレンダー"
            case .selectPhotoOptional: return "写真を選択（任意）"
            case .selectedTodayPhoto: return "写真を選択済み"
            case .photoLabel: return "写真"
            case .minuteUnit: return "分"
            case .secondUnit: return "秒"
            case .dayUnit: return "日"
            case .notCompletedYet: return "未達成"
            case .done: return "完了"
            case .ok: return "OK"
            case .cancel: return "キャンセル"
            case .settingsLanguage: return "言語"
            case .settingsLogin: return "ログイン方法（準備）"
            case .settingsLoginHint: return "このバージョンではログイン選択のみ実装しています。"
            case .loginApple: return "Apple"
            case .loginGoogle: return "Google"
            case .loginEmail: return "メール"
            }
        case .ko:
            switch key {
            case .tabMorning: return "아침"
            case .tabGratitude: return "감사"
            case .tabMeditation: return "명상"
            case .tabUniverse: return "우주"
            case .tabSettings: return "설정"
            case .morningTitle: return "아침 To-Do"
            case .gratitudeTitle: return "감사 일기"
            case .meditationTitle: return "취침 전 명상"
            case .universeTitle: return "우주"
            case .settingsTitle: return "설정"
            case .add: return "추가"
            case .addTodoPlaceholder: return "할 일 추가"
            case .saveGratitude: return "감사 저장"
            case .start: return "시작"
            case .stop: return "정지"
            case .changeQuote: return "문구 바꾸기"
            case .today: return "오늘"
            case .streak: return "연속 달성"
            case .latestCompletion: return "최근 완료일"
            case .quoteNoticeHint: return "매일 3시간마다 우주 문구 알림이 옵니다."
            case .completedMeditation: return "명상 1회를 완료했습니다."
            case .progress: return "오늘 진행률"
            case .doneProgress: return "완료"
            case .mood: return "기분"
            case .gratitudePrompt: return "오늘 밤 감사한 일을 적어보세요"
            case .universeQuote: return "우주 문구"
            case .defaultMorningTodo: return "오늘 가장 중요한 한 가지를 적기"
            case .calendar: return "달력"
            case .selectPhotoOptional: return "사진 선택(선택사항)"
            case .selectedTodayPhoto: return "사진이 선택됨"
            case .photoLabel: return "사진"
            case .minuteUnit: return "분"
            case .secondUnit: return "초"
            case .dayUnit: return "일"
            case .notCompletedYet: return "아직 완료되지 않음"
            case .done: return "완료"
            case .ok: return "확인"
            case .cancel: return "취소"
            case .settingsLanguage: return "언어"
            case .settingsLogin: return "로그인 방식(준비)"
            case .settingsLoginHint: return "이번 버전은 로그인 선택만 제공합니다."
            case .loginApple: return "Apple"
            case .loginGoogle: return "Google"
            case .loginEmail: return "이메일"
            }
        }
    }
}
